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
        //|> RoundCornerImageProcessor(cornerRadius: 6)
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
        
        btBackground.kf.setBackgroundImage(
            with: viewModel.thumbnail,
            for: .normal,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.4)),
                .cacheOriginalImage
            ]
        )
        
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
//        contentView.makeConstraints { it in
//            it.edgesConstraintToSuperview(edges: .all)
//            it.heightAnchorConstraintTo(CharactersListItemCell.height).priority = .required
//        }
        contentView.backgroundColor = .yellow
        
        btBackground.also { it in
            it.backgroundColor = .secondarySystemBackground
            it.imageView?.kf.indicatorType = .activity
            contentView.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: .all)
                // $0.bottomAnchorConstraintToSuperview()?.priority = .defaultHigh
               // $0.heightAnchorConstraintTo(CharactersListItemCell.height)
            }
        }
        btBackground.addTarget(self, action: #selector(onClickItem), for: .touchUpInside)
        
        lbTitle.also { it in
            it.backgroundColor = UIColor.tertiarySystemFill
            it.numberOfLines = 0
            it.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            it.textColor = UIColor.label
            it.textAlignment = .natural
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintToSuperview(20)
                $0.topAnchorConstraintToSuperview(20)
                $0.trailingAnchor
                    .constraint(lessThanOrEqualTo: btBackground.trailingAnchor, constant: -40)
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
                $0.trailingAnchor
                    .constraint(lessThanOrEqualTo: btBackground.trailingAnchor, constant: -40)
                    .isActive = true
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
            contentView.addSubview(it)
            it.makeConstraints {
                $0.trailingAnchorConstraintToSuperview(-20)
                $0.bottomAnchorConstraintToSuperview(-20)
            }
        }
        btThumb.addTarget(self, action: #selector(onClickFavorite), for: .touchUpInside)
        
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
    
    private func makeCountLabel(_ lb: UILabel, to stack: UIStackView) {
        lb.numberOfLines = 1
        lb.font = .systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .lightGray
        stack.addArrangedSubview(lb)
    }
}



struct CharactersListItemCell_Preview: PreviewProvider {
    static let sample1 = CharactersListItemViewModel(
        id: 1, name: "Name1", thumbnail: nil,
        urlsCount: 10, comicsCount: 1, storiesCount: 2, eventsCount: 3, seriesCount: 4,
        isFavorite: true, favoritedAt: Date())
    static let sample2 = CharactersListItemViewModel(
        id: 1, name: "Name2 abcde asdf sdf abcde asdf sdf", thumbnail: URL(string: "https://picsum.photos/500")!,
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
