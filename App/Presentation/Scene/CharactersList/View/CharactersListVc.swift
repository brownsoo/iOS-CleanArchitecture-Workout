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
    
    private var viewModel: CharactersListViewModel?
    private var listTableVc: CharactersTableVc?
    private let emptyLabel = UILabel()
    private let listViewContainer = UIView()
    private let lbLicense = UILabel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel?.refresh(forced: false)
        
        // TODO: 좋아요 화면의 변경사항을 반영
    }
    
}

extension CharactersListVc {
    private func setupViews() {
        self.title = "Marvel Characters"
        self.view.backgroundColor = .systemBackground
        
        let thumbImage = UIImage(systemName: "hand.thumbsup",
                                 withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .systemMint))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                                 image: thumbImage,
                                                                 target: self,
                                                                 action: #selector(navigateToFavoriteView))
        
        listViewContainer.also { it in
            it.backgroundColor = .yellow
            view.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all)
            }
        }
        
        lbLicense.also { it in
            it.text = "Data provided by Marvel. © 2023 Marvel"
            it.textAlignment = .center
            it.textColor = .secondaryLabel
            it.backgroundColor = .secondarySystemGroupedBackground
            view.addSubview(it)
            it.makeConstraints {
                $0.centerXAnchorConstraintToSuperview()
                $0.bottomAnchorConstraintTo(view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
                $0.sizeToFit()
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
