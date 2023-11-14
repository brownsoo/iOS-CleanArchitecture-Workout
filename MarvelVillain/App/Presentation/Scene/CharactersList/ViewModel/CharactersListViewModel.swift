//
//  CharactersListViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation
import Combine
import Shared

protocol CharactersListViewModel: ViewModel {
    // in-
    func onReveal() -> Void
    func refresh(forced: Bool) -> Void
    func loadNextPage() -> Void
    func didSelectItem(at index: Int) -> Void
    func didSelectItem(characterId: Int) -> Void
    func toggleFavorited(characterId: Int) -> Void
    func showFavoritesList() -> Void
    // out -
    var emtpyLabelText: String { get }
    var items: AnyPublisher<[CharactersListItemViewModel], Never> { get }
    var itemsIsEmpty: Bool { get }
    var itemsAllLoaded: AnyPublisher<Bool, Never> { get }
    var loadings: AnyPublisher<ListLoading, Never> { get }
}


