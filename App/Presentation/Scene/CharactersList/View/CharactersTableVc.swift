//
//  CharactersListTableVc.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Combine

final class CharactersTableVc: UITableViewController {
    
    static func create(viewModel: CharactersListViewModel?) -> CharactersTableVc {
        let vc = CharactersTableVc()
        vc.viewModel = viewModel
        return vc
    }
    
    var viewModel: CharactersListViewModel?
    
    private var pageLoadingSpinner: UIActivityIndicatorView?
    private var cancellables: Set<AnyCancellable> = []
    private let cellClickPublisher = PassthroughSubject<CharactersListItemClickType, Never>()
    private lazy var bannerAllLoaded: UILabel = {
        let lb = UILabel()
        lb.text = "All Characters are loaded."
        lb.backgroundColor = .systemYellow
        lb.textColor = .label
        lb.textAlignment = .center
        lb.alpha = 0
        lb.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .bold)
        lb.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return lb
    }()
    private lazy var dataSource = makeDataSource()
    
    private enum Section: CaseIterable {
        case characters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindData()
    }
    
    func updateLoading(_ loading: ListLoading) {
        switch loading {
            case .next:
                pageLoadingSpinner?.removeFromSuperview()
                pageLoadingSpinner = makeActivityIndicator(size: CGSize(width: tableView.frame.width, height: 44))
                tableView.tableFooterView = pageLoadingSpinner
            default:
                tableView.tableFooterView = nil
        }
    }
}

extension CharactersTableVc {
    private func setupViews() {
        tableView.delaysContentTouches = true
        tableView.estimatedRowHeight = CharactersListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.register(CharactersListItemCell.self, forCellReuseIdentifier: CharactersListItemCell.reuseIdentifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        foot()
        viewModel?.refresh(forced: true)
    }
    
    private func bindData() {
        guard let vm = viewModel else { return }
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        vm.items.sink { items in
            self.updateView(with: items)
        }
        .store(in: &cancellables)
        
        vm.itemsAllLoaded
            .removeDuplicates().sink { v in
                if v {
                    debugPrint("다 불러옴.")
                    self.showAllLoaded()
                }
            }
            .store(in: &cancellables)
        
        cellClickPublisher.throttle(for: 1.0, scheduler: Scheduler.masinScheduler, latest: true)
            .sink { type in
                foot("\(type)")
                self.handleCellClick(type)
            }
            .store(in: &cancellables)
    }
    
    private func showAllLoaded() {
        if bannerAllLoaded.superview == nil {
            view.addSubview(bannerAllLoaded)
            bannerAllLoaded.makeConstraints { it in
                it.widthAnchorConstraintTo(view.bounds.width)
                it.heightAnchorConstraintTo(bannerAllLoaded.font.pointSize * 2)
                it.topAnchorConstraintToSuperview()
            }
            bannerAllLoaded.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .beginFromCurrentState,
                           animations: {
                self.bannerAllLoaded.alpha = 0
            }) { [weak self] _ in
                self?.bannerAllLoaded.removeFromSuperview()
            }
        }
    }
    
    private func handleCellClick(_ type: CharactersListItemClickType) {
        guard let vm = viewModel else { return }
        switch type {
            case .favorite(let characterId):
                vm.toggleFavorited(characterId: characterId)
            case .item(let characterId):
                vm.didSelectItem(characterId: characterId)
        }
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, CharactersListItemViewModel> {
        return UITableViewDiffableDataSource(
            tableView: self.tableView) { [weak self] tableView, indexPath, itemViewModel in
                guard let this = self,
                      let cell = tableView.dequeueReusableCell(withIdentifier: CharactersListItemCell.reuseIdentifier) as? CharactersListItemCell else {
                    assertionFailure("Cell 클래스 \(CharactersListItemCell.self) 없음.")
                    return UITableViewCell()
                }
                cell.accessibilityIdentifier = "CharactersListItemCell.\(indexPath.row)"
                cell.fill(with: itemViewModel)
                cell.delegate = this
                
                let snapshot = this.dataSource.snapshot().itemIdentifiers.count
                if indexPath.row == snapshot - 1{
                    this.viewModel?.loadNextPage()
                }
                return cell
            }
    }
    
    private func updateView(with items: [CharactersListItemViewModel], animating: Bool = true) {
        foot("\(items.count)")
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot() //NSDiffableDataSourceSnapshot<Section, CharactersListItemViewModel>()
            snapshot.deleteAllItems()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(items, toSection: .characters)
            self.dataSource.apply(snapshot, animatingDifferences: animating)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension CharactersTableVc: CharactersListItemCellDelegate {
    func charactersListItemClicked(type: CharactersListItemClickType) {
        cellClickPublisher.send(type)
    }
}
