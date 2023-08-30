//
//  CharactersListItemCell.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import SwiftUI
import Kingfisher

enum CharactersListItemClickType {
    case item(characterId: Int)
    case favorite(characterId: Int)
}

protocol CharactersListItemCellDelegate {
    func charactersListItemClicked(type: CharactersListItemClickType)
}

final class CharactersListItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CharactersListItemCell.self)
    static let height = CGFloat(200)
    
    private let btBackground = UIButton(type: .custom)
    private let ivRepresent = UIImageView()
    private let lbTitle = UILabel()
    private let lbComicsCount = UILabel()
    private let lbEventsCount = UILabel()
    private let lbSeriesCount = UILabel()
    private let lbStoriesCount = UILabel()
    private let lbUrlsCount = UILabel()
    private let stackCount = UIStackView()
    private let thumbImage = UIImage(
        systemName: "hand.thumbsup",
            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28))
            .applying(UIImage.SymbolConfiguration(hierarchicalColor: .systemMint)))
    private let thumbImageFill = UIImage(
        systemName: "hand.thumbsup.fill",
        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28))
            .applying(UIImage.SymbolConfiguration(hierarchicalColor: .systemMint)))
    private let thumbImageFillHighlight = UIImage(
        systemName: "hand.thumbsup.fill",
        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 28))
            .applying(UIImage.SymbolConfiguration(hierarchicalColor: .systemMint.withAlphaComponent(0.5))))
    
    private let btThumb = UIButton(type: .custom)
    
    private lazy var processor: ImageProcessor = {
        DownsamplingImageProcessor(size: contentView.bounds.size)
    }()
    
    private var characterId: Int = -1
    var delegate: CharactersListItemCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func fill(with viewModel: CharactersListItemViewModel) {
        characterId = viewModel.id
        
        ivRepresent.kf.setImage(
            with: viewModel.thumbnail,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.4)),
                .cacheOriginalImage
            ], completionHandler:  { result in
                switch result {
                    case .success(let value):
                        foot("\(value.cacheType) -> \(value.source.url?.absoluteString ?? "?")")
                    case .failure(let error):
                        foot("\(error.localizedDescription)")
                }
            })
        
        lbTitle.text = viewModel.name
        lbComicsCount.text = "\(viewModel.comicsCount) Comics"
        lbEventsCount.text = "\(viewModel.eventsCount) Events"
        lbSeriesCount.text = "\(viewModel.seriesCount) Series"
        lbStoriesCount.text = "\(viewModel.storiesCount) Stories"
        lbUrlsCount.text = "\(viewModel.urlsCount) Urls"
        btThumb.isSelected = viewModel.isFavorite
        
    }
}

extension CharactersListItemCell {
    private func setupViews() {
        ivRepresent.also { it in
            contentView.addSubview(it)
            it.backgroundColor = .secondarySystemBackground
            it.contentMode = .scaleAspectFill
            it.clipsToBounds = true
            it.kf.indicatorType = .activity
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: [.top, .horizontal])
                $0.heightAnchorConstraintTo(CharactersListItemCell.height)
                $0.bottomAnchorConstraintToSuperview()?.priority = .init(999)
            }
        }
        
        btBackground.also { it in
            it.setBackgroundImage(UIImage().solid(.white.withAlphaComponent(0.1)), for: .highlighted)
            contentView.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintTo(ivRepresent.safeAreaLayoutGuide, edges: .all)
            }
        }
        btBackground.addTarget(self, action: #selector(onClickItem), for: .touchUpInside)
        
        lbTitle.also { it in
            it.backgroundColor = UIColor.lightText
            it.numberOfLines = 0
            it.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            it.textColor = UIColor.label
            it.textAlignment = .natural
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(20)
                $0.topAnchorConstraintToSuperview(20)
                $0.trailingAnchor
                    .constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50)
                    .isActive = true
            }
        }
        
        stackCount.also { it in
            it.axis = .horizontal
            it.spacing = 10
            it.alignment = .center
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(20)
                $0.bottomAnchorConstraintToSuperview(-20)
//                $0.trailingAnchor
//                    .constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40)
//                    .isActive = true
            }
        }
        
        makeCountLabel(lbComicsCount, to: stackCount)
        makeCountLabel(lbEventsCount, to: stackCount)
        makeCountLabel(lbSeriesCount, to: stackCount)
        makeCountLabel(lbStoriesCount, to: stackCount)
        makeCountLabel(lbUrlsCount, to: stackCount)
        
        btThumb.also { it in
            it.setImage(thumbImage, for: .normal)
            it.setImage(thumbImageFillHighlight, for: .highlighted)
            it.setImage(thumbImageFill, for: .selected)
            var configuration = UIButton.Configuration.filled()
            configuration.imagePadding = 10
            configuration.baseBackgroundColor = .clear
            it.configuration = configuration
            contentView.addSubview(it)
            it.makeConstraints {
                $0.trailingAnchorConstraintToSuperview(-10)
                $0.topAnchorConstraintToSuperview(20)
            }
        }
        btThumb.addTarget(self, action: #selector(onClickFavorite), for: .touchUpInside)
        
    }
    
    private func makeCountLabel(_ lb: UILabel, to stack: UIStackView) {
        lb.numberOfLines = 1
        lb.font = .systemFont(ofSize: 14, weight: .medium)
        lb.textColor = .lightText
        lb.backgroundColor = UIColor.darkText
        stack.addArrangedSubview(lb)
    }
    
    @objc private func onClickFavorite() {
        if characterId > 0 {
            delegate?.charactersListItemClicked(type: .favorite(characterId: characterId))
        }
    }
    
    @objc private func onClickItem() {
        if characterId > 0 {
            delegate?.charactersListItemClicked(type: .item(characterId: characterId))
        }
    }
    
}



struct CharactersListItemCell_Preview: PreviewProvider {
    static let sample1 = CharactersListItemViewModel(
        id: 1, name: "Name1",
        thumbnail: URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
        urlsCount: 10, comicsCount: 1, storiesCount: 2, eventsCount: 3, seriesCount: 4,
        isFavorite: true, favoritedAt: Date())
    static let sample2 = CharactersListItemViewModel(
        id: 1, name: "Name2 abcde asdf sdf abcde asdf sdf",
        thumbnail: URL(string: "https://picsum.photos/500"),
        urlsCount: 10, comicsCount: 1, storiesCount: 2, eventsCount: 3, seriesCount: 4,
        isFavorite: false)
    
    static var previews: some View {
        let cell1 = CharactersListItemCell()
        let cell2 = CharactersListItemCell()
        return VStack {
            UIViewPreview {
                cell1
            }
            .frame(height: 200)
            .onAppear {
                cell1.fill(with: sample1)
            }
            
            UIViewPreview {
                cell2
            }
            .frame(height: 200)
            .onAppear {
                cell2.fill(with: sample2)
            }
            
            Spacer()
            
        }
        .previewLayout(.sizeThatFits)
    }
}
