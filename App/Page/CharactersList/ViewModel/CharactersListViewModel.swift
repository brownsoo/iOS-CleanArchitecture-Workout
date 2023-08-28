//
//  CharactersListViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation
import Combine

struct CharactersListViewModelActions {
    let showCharacterDetails: (MarvelCharacter) -> Void
    let showFavorites: () -> Void
}

enum CharactersLoading {
    case none
    case first
    case next
}

protocol CharactersListViewModel {
    // in-
    func didSelectItem(at index: Int) -> Void
    func makrFavorite(character: MarvelCharacter) -> Void
    func unmarkFavorte(character: MarvelCharacter) -> Void
    // out -
    var items: AnyPublisher<[CharactersListItemViewModel], Never> { get }
    var loading: AnyPublisher<CharactersLoading, Never> { get }
}

final class DefaultCharactersListViewModel {
    private let actions: CharactersListViewModelActions?
    
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private var hasMorePages: Bool { currentPage < totalPages }
    private var naxtPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [PagedData<MarvelCharacter>] = []
    private var loadTask: Cancellable? {
        willSet {
            loadTask?.cancel()
        }
    }
    private let _items = CurrentValueSubject<[CharactersListItemViewModel], Never>([])
    private let _loading = CurrentValueSubject<CharactersLoading, Never>(.none)
    
    init(actions: CharactersListViewModelActions) {
        self.actions = actions
    }
    
    private func appendPage(_ page: PagedData<MarvelCharacter>) {
        
    }
}
