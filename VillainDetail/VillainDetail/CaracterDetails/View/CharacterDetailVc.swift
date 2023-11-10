//
//  CharacterDetailVc.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Combine
import SwiftUI
import Kingfisher
import SafariServices
import Shared

public class CharacterDetailVc: UIViewController, Alertable {
    
    public static func create(viewModel: CharacterDetailViewModel) -> CharacterDetailVc {
        let vc = CharacterDetailVc()
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: CharacterDetailViewModel?
    private var cancellables: Set<AnyCancellable> = []
    private let ivRepresent = UIImageView()
    private let btDownloadImage = UIButton(type: .custom)
    private let btUrls = UIButton(type: .roundedRect)
    private var btFavorite: UIBarButtonItem!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
}

public extension CharacterDetailVc {
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        self.title = viewModel?.characterName
        
        btFavorite = UIBarButtonItem(image: UIImage(systemName: "star"),
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(onClickFavorite))
        navigationItem.rightBarButtonItem = btFavorite
        
        ivRepresent.also { it in
            view.addSubview(it)
            it.contentMode = .scaleAspectFill
            it.backgroundColor = .secondarySystemBackground
            it.clipsToBounds = true
            it.makeConstraints {
                $0.topAnchorConstraintTo(view.safeAreaLayoutGuide.topAnchor)
                $0.leadingAnchorConstraintTo(view.safeAreaLayoutGuide.leadingAnchor)
                $0.trailingAnchorConstraintTo(view.safeAreaLayoutGuide.trailingAnchor)
                $0.heightAnchorConstraintTo(300)
            }
        }
        btDownloadImage.also { it in
            view.addSubview(it)
            it.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
            it.tintColor = .white
            it.makeConstraints {
                $0.trailingAnchorConstraintTo(ivRepresent, constant: -20)
                $0.bottomAnchorConstraintTo(ivRepresent, constant: -20)
            }
        }
        
        btUrls.also { it in
            view.addSubview(it)
            it.configuration = UIButton.Configuration.filled()
            it.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(30)
                $0.trailingAnchorConstraintToSuperview(-30)
                $0.topAnchorConstraintTo(ivRepresent.bottomAnchor, constant: 20)
            }
        }
    }
    private func bindViewModel() {
        viewModel?.stateChanges
            .receive(on: RunLoop.main)
            .sink {
            self.updateView($0)
        }
        .store(in: &cancellables)
        
        btDownloadImage.addTarget(self, action: #selector(onClickDownload), for: .touchUpInside)
        btUrls.addTarget(self, action: #selector(onClickUrl), for: .touchUpInside)
    }
    
    private func updateView(_ data: DetailViewState) {
        ivRepresent.kf.setImage(with: data.thumbnail)
        
        if data.url != nil {
            btUrls.setTitle("자세한 정보", for: .normal)
            btUrls.isEnabled = true
        } else {
            btUrls.setTitle("No Urls", for: .normal)
            btUrls.isEnabled = false
        }
        if data.isFavorite {
            btFavorite.image = UIImage(systemName: "star.fill")
        } else {
            btFavorite.image = UIImage(systemName: "star")
        }
    }
    
    @objc private func onClickFavorite() {
        viewModel?.toggleFavorited()
    }
    
    @objc private func onClickDownload() {
        if let url = viewModel?.state.thumbnail {
            let downloader = ImageDownloader.default
            downloader.downloadImage(with: url) { [weak self] result in
                guard let this = self else { return }
                switch result {
                    case .success(let value):
                        UIImageWriteToSavedPhotosAlbum(value.image, this, #selector(this.didImageDownload), nil)
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    @objc private func didImageDownload(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(message: error.localizedDescription)
        } else {
            showAlert(message: "앨범 저장 완료.")            
        }
    }
    
    @objc private func onClickUrl() {
        if let url = viewModel?.state.url {
            openUrl(url)
        }
    }
    
    private func openUrl(_ url: URL) {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = self
        self.present(vc, animated: true)
        
    }
}


extension CharacterDetailVc: SFSafariViewControllerDelegate {
    
}


struct CharacterDetailVc_Preview: PreviewProvider {
    
    static var previews: some View {
        UIViewControllerPreview {
            UINavigationController(
                rootViewController: CharacterDetailVc.create(viewModel: MockCharacterDetailViewModel())
            )
        }
    }
}
