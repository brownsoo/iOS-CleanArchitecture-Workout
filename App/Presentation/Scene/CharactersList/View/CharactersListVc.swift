//
//  CharactersListVc.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/24.
//

import UIKit
import Combine

class CharactersListVc: UIViewController, Alertable {
    
    static func create(viewModel: CharactersListViewModel) -> CharactersListVc {
        let vc = CharactersListVc()
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: CharactersListViewModel!
    private var listTableVc: CharactersListTableVc?
    private var emptyLabel: UILabel!
    private var listViewContainer: UIView!
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.refresh()
    }
}

extension CharactersListVc {
    private func setupViews() {
        self.title = "Marvel Characters"
        listViewContainer = UIView()
        view.addSubview(listViewContainer)
        listViewContainer.makeConstraints { it in
            it.edgesConstraintTo(self.view.safeAreaLayoutGuide, edges: .all, withInset: 0)
        }
        
        let vc = CharactersListTableVc()
        add(child: vc, container: listViewContainer)
        vc.viewModel = self.viewModel
        listTableVc = vc
        
        emptyLabel = UILabel()
        view.addSubview(emptyLabel)
        emptyLabel.makeConstraints { it in
            it.centerXAnchorConstraintToSuperview()
            it.centerYAnchorConstraintToSuperview()
        }
        emptyLabel.also { it in
            it.font = UIFont.systemFont(ofSize: 14, weight: .light)
            it.textColor = .tertiaryLabel
            it.text = viewModel.emtpyLabelText
            it.sizeToFit()
            it.isHidden = false
        }
    }
    
    private func bindViewModel() {
        viewModel.loadings
            .sink { self.updateLoading($0) }
            .store(in: &cancellables)
        viewModel.errorMessages
            .sink { self.showError(message: $0) }
            .store(in: &cancellables)
        
    }
    
    private func updateLoading(_ loading: ListLoading) {
        emptyLabel.isHidden = true
        listViewContainer.isHidden = true
        LoadingView.hide()
        
        switch loading {
            case .first:
                LoadingView.show()
            case .next:
                listViewContainer.isHidden = false
            case .idle:
                listViewContainer.isHidden = viewModel.itemsIsEmpty
                emptyLabel.isHidden = !viewModel.itemsIsEmpty
        }
        
        listTableVc?.updateLoading(loading)
    }
    
    private func showError(message: String) {
        guard !message.isEmpty else { return }
        showAlert(message: message)
    }
}
