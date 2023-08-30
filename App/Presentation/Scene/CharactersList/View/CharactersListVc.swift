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
    private var listTableVc: CharactersListTableVc?
    private let emptyLabel = UILabel()
    private let listViewContainer = UIView()
    private let lbLicense = UILabel()
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.refresh()
    }
}

extension CharactersListVc {
    private func setupViews() {
        self.title = "Marvel Characters"
        
        listViewContainer.also { it in
            view.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all)
            }
        }
        
        lbLicense.also { it in
            it.text = "Data provided by Marvel. © 2014 Marvel"
            it.textAlignment = .center
            it.textColor = .secondaryLabel
            view.addSubview(it)
            it.makeConstraints {
                $0.centerXAnchorConstraintToSuperview()
                $0.bottomAnchorConstraintTo(view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
                $0.sizeToFit()
            }
        }
        
        let vc = CharactersListTableVc.create(viewModel: self.viewModel)
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
                LoadingView.show()
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
}
