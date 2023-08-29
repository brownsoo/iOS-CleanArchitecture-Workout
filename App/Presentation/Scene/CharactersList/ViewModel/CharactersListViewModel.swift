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
    func loadNextPage() -> Void
    func didSelectItem(at index: Int) -> Void
    func markFavorite(character: MarvelCharacter) -> Void
    func unmarkFavorte(character: MarvelCharacter) -> Void
    // out -
    var items: AnyPublisher<[CharactersListItemViewModel], Never> { get }
    var loading: AnyPublisher<CharactersLoading, Never> { get }
}


private extension Array where Element == PagedData<MarvelCharacter> {
    var characters: [MarvelCharacter] {
        self.flatMap { $0.items }
    }
}


final class DefaultCharactersListViewModel: BaseViewModel {
    private let actions: CharactersListViewModelActions?
    private let repository: CharactersRepository
    
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
    private let maingQueue = DispatchQueue.main
    private let _items = CurrentValueSubject<[CharactersListItemViewModel], Never>([])
    private let _loading = CurrentValueSubject<CharactersLoading, Never>(.none)
    
    init(actions: CharactersListViewModelActions,
         characterRepository: CharactersRepository) {
        self.actions = actions
        self.repository = characterRepository
    }
    
    private func appendPage(_ newPage: PagedData<MarvelCharacter>) {
        currentPage = newPage.page
        totalPages = newPage.totalPages
        pages = pages.filter({ $0.page != newPage.page }) + [newPage]
        
        _items.send(pages.characters.map(CharactersListItemViewModel.init))
    }
    
    private func resetPages() {
        currentPage = 0
        totalPages = 0
        pages.removeAll()
        _items.send([])
    }
    
    private func load(loading: CharactersLoading) {
        _loading.send(loading)
        loadTask = repository.fetchList(
            page: naxtPage,
            onCached: { [weak self] page in
                guard let newPage = page else { return }
                self?.maingQueue.async {
                    self?.appendPage(newPage)
                }
            },
            onFetched: { [weak self] result in
                self?.maingQueue.async {
                    switch result {
                        case .success(let newPage):
                            self?.appendPage(newPage)
                        case .failure(let error):
                            self?.handleError(error)
                    }
                    self?._loading.send(.none)
                }
            })
    }
}

extension DefaultCharactersListViewModel {
    func refresh() {
        resetPages()
        load(loading: .first)
    }
}

extension DefaultCharactersListViewModel: CharactersListViewModel {
    
    func loadNextPage() {
        guard hasMorePages, _loading.value == .none else { return }
        load(loading: .next)
    }
    
    func didSelectItem(at index: Int) {
        actions?.showCharacterDetails(pages.characters[index])
    }
    
    func markFavorite(character: MarvelCharacter) {
        repository.favorite(character: character) { result in
            if case let .failure(error) = result {
                self.handleError(error)
            } else {
                // 좋아요 마크
                var news = self._items.value
                if let index = news.firstIndex(where: { $0.id == character.id }) {
                    news[index].isFavorite = true
                    news[index].favoritedAt = Date()
                    self._items.send(news)
                }
            }
        }
        .store(in: &cancellabels)
    }
    
    func unmarkFavorte(character: MarvelCharacter) {
        repository.unfavorite(character: character) { result in
            if case let .failure(error) = result {
                self.handleError(error)
            } else {
                // 안 좋아요 마크
                var news = self._items.value
                if let index = news.firstIndex(where: { $0.id == character.id }) {
                    news[index].isFavorite = false
                    news[index].favoritedAt = nil
                    self._items.send(news)
                }
            }
        }
        .store(in: &cancellabels)
    }
    
    var items: AnyPublisher<[CharactersListItemViewModel], Never> {
        _items.eraseToAnyPublisher()
    }
    
    var loading: AnyPublisher<CharactersLoading, Never> {
        _loading.eraseToAnyPublisher()
    }
    
    
}
