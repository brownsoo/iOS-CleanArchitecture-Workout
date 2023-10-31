//
//  FavoritesListVc.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Combine
import Shared

final class FavoritesListVc: UIViewController, Alertable {
    static func create(viewModel: CharactersListViewModel) -> FavoritesListVc {
        let vc = FavoritesListVc()
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: CharactersListViewModel!
    private var listTableVc: CharactersTableVc?
    private let emptyLabel = UILabel()
    private let listViewContainer = UIView()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel?.refresh(forced: false)
    }
}

extension FavoritesListVc {
    private func setupViews() {
        self.title = "My Characters"
        self.view.backgroundColor = .systemBackground
        
        listViewContainer.also { it in
            it.backgroundColor = .yellow
            view.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all)
            }
        }
        
        let vc = CharactersTableVc.create(viewModel: self.viewModel)
        add(childVc: vc, container: listViewContainer)
        listTableVc = vc

        emptyLabel.also { it in
            it.font = UIFont.systemFont(ofSize: 14, weight: .light)
            it.textColor = .tertiaryLabel
            it.text = viewModel?.emtpyLabelText
            it.sizeToFit()
            it.isHidden = false
            view.addSubview(it)
            it.makeConstraints {
                $0.centerXAnchorConstraintToSuperview()
                $0.centerYAnchorConstraintToSuperview()
            }
        }
    }
    
    private func bindViewModel() {
        viewModel?.loadings
            .sink { self.updateLoading($0) }
            .store(in: &cancellables)
        viewModel?.errorMessages
            .sink { self.showError(message: $0) }
            .store(in: &cancellables)
        
    }
    
    private func updateLoading(_ loading: ListLoading) {
        foot("\(loading)")
        emptyLabel.isHidden = true
        listViewContainer.isHidden = true
        LoadingView.hide()
        
        switch loading {
            case .first:
                LoadingView.show(parent: self.view)
            case .next:
                listViewContainer.isHidden = false
            case .idle:
                listViewContainer.isHidden = viewModel?.itemsIsEmpty == true
                emptyLabel.isHidden = viewModel?.itemsIsEmpty == false
        }
        
        listTableVc?.updateLoading(loading)
    }
    
    private func showError(message: String) {
        guard !message.isEmpty else { return }
        showAlert(message: message)
    }
    
    @objc private func navigateToFavoriteView() {
        viewModel?.showFavoritesList()
    }
}
