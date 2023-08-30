//
//  CharactersListItemCell.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import SwiftUI
import Kingfisher

final class CharactersListItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CharactersListItemCell.self)
    static let height = CGFloat(200)
    
    private let ivRepresent: UIImageView = UIImageView()
    private let lbTitle: UILabel = UILabel()
    private let lbComicsCount: UILabel = UILabel()
    private let lbEventsCount: UILabel = UILabel()
    private let lbSeriesCount: UILabel = UILabel()
    private let lbStoriesCount: UILabel = UILabel()
    private let lbUrlsCount: UILabel = UILabel()
    private let stackCount: UIStackView = UIStackView()
    
    private lazy var processor: ImageProcessor = {
        DownsamplingImageProcessor(size: contentView.bounds.size)
        //|> RoundCornerImageProcessor(cornerRadius: 6)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func fill(with viewModel: CharactersListItemViewModel) {
        ivRepresent.kf.setImage(
            with: viewModel.thumbnail,
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
    }
}

extension CharactersListItemCell {
    private func setupViews() {
        contentView.makeConstraints { it in
            it.edgesConstraintToSuperview(edges: .all)
        }
        
        ivRepresent.also { it in
            it.backgroundColor = .secondarySystemBackground
            it.kf.indicatorType = .activity
            contentView.addSubview(it)
            it.makeConstraints {
                $0.edgesConstraintToSuperview(edges: [.horizontal, .top])
                $0.bottomAnchorConstraintToSuperview()?.priority = .defaultHigh
                $0.heightAnchorConstraintTo(CharactersListItemCell.height)
            }
        }
        
        lbTitle.also { it in
            it.backgroundColor = UIColor.tertiarySystemFill
            it.numberOfLines = 0
            it.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            it.textColor = UIColor.label
            it.textAlignment = .natural
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintTo(ivRepresent, constant: 20)
                $0.topAnchorConstraintTo(ivRepresent, constant: 20)
                $0.trailingAnchor
                    .constraint(lessThanOrEqualTo: ivRepresent.trailingAnchor, constant: -40)
                    .isActive = true
            }
        }
        
        stackCount.also { it in
            it.axis = .horizontal
            it.spacing = 10
            it.alignment = .center
            contentView.addSubview(it)
            it.makeConstraints {
                $0.leadingAnchorConstraintTo(ivRepresent, constant: 20)
                $0.bottomAnchorConstraintTo(ivRepresent, constant: -20)
                $0.trailingAnchor
                    .constraint(lessThanOrEqualTo: ivRepresent.trailingAnchor, constant: -40)
                    .isActive = true
            }
        }
        
        makeCountLabel(lbComicsCount, to: stackCount)
        makeCountLabel(lbEventsCount, to: stackCount)
        makeCountLabel(lbSeriesCount, to: stackCount)
        makeCountLabel(lbStoriesCount, to: stackCount)
        makeCountLabel(lbUrlsCount, to: stackCount)
        
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
            .onAppear {
                cell1.fill(with: sample1)
            }
            .previewLayout(.sizeThatFits)
            
            UIViewPreview {
                cell2
            }
            .onAppear {
                cell2.fill(with: sample2)
            }
            .previewLayout(.sizeThatFits)
            
            Spacer()
        }
    }
}
