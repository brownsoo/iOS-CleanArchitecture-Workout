//
//  CharactersListTableVc.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Combine

final class CharactersListTableVc: UITableViewController {
    
    var viewModel: CharactersListViewModel?
    
    private var pageLoadingSpinner: UIActivityIndicatorView?
    private var cancellables: Set<AnyCancellable> = []
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

extension CharactersListTableVc {
    private func setupViews() {
        tableView.estimatedRowHeight = CharactersListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CharactersListItemCell.self, forCellReuseIdentifier: CharactersListItemCell.reuseIdentifier)
    }
    
    private func bindData() {
        guard let vm = viewModel else { return }
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        vm.items.sink { items in
            self.updateView(with: items)
        }
        .store(in: &cancellables)
        
        vm.itemsAllLoaded.removeDuplicates().sink { v in
            if v {
                // TODO: show banner
                debugPrint("다 불러옴.")
            }
        }
    }
    
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, CharactersListItemViewModel> {
        return UITableViewDiffableDataSource(
            tableView: self.tableView) { tableView, indexPath, itemViewModel in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersListItemCell.reuseIdentifier) as? CharactersListItemCell else {
                    assertionFailure("Cell 클래스 \(CharactersListItemCell.self) 없음.")
                    return UITableViewCell()
                }
                cell.accessibilityIdentifier = "CharactersListItemCell.\(indexPath.row)"
                cell.fill(with: itemViewModel)
                return cell
            }
    }
    
    private func updateView(with items: [CharactersListItemViewModel], animating: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, CharactersListItemViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(items, toSection: .characters)
            self.dataSource.apply(snapshot, animatingDifferences: animating)
        }
    }
    
    
}
// MARK: - UITableViewDataSource, UITableViewDelegate

extension CharactersListTableVc {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        viewModel?.didSelectItem(item: snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
