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
    let showFavorites: VoidCallback?
}

protocol CharactersListViewModel: ViewModel {
    // in-
    func refresh() -> Void
    func loadNextPage() -> Void
    func didSelectItem(at index: Int) -> Void
    func didSelectItem(item: CharactersListItemViewModel) -> Void
    func markFavorite(character: MarvelCharacter) -> Void
    func unmarkFavorte(character: MarvelCharacter) -> Void
    // out -
    var emtpyLabelText: String { get }
    var items: AnyPublisher<[CharactersListItemViewModel], Never> { get }
    var itemsIsEmpty: Bool { get }
    var itemsAllLoaded: AnyPublisher<Bool, Never> { get }
    var loadings: AnyPublisher<ListLoading, Never> { get }
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
    private let _itemsAllLoaded = PassthroughSubject<Bool, Never>()
    private let _items = CurrentValueSubject<[CharactersListItemViewModel], Never>([])
    private let _loading = CurrentValueSubject<ListLoading, Never>(.idle)
    
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
        
        if newPage.items.count < kQueryLimit {
            _itemsAllLoaded.send(true)
        }
    }
    
    private func resetPages() {
        currentPage = 0
        totalPages = 0
        pages.removeAll()
        _items.send([])
    }
    
    private func load(loading: ListLoading) {
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
                    self?._loading.send(.idle)
                }
            })
    }
}


extension DefaultCharactersListViewModel: CharactersListViewModel {
    
    func refresh() {
        resetPages()
        load(loading: .first)
    }
    
    func loadNextPage() {
        guard hasMorePages, _loading.value == .idle else { return }
        load(loading: .next)
    }
    
    func didSelectItem(at index: Int) {
        actions?.showCharacterDetails(pages.characters[index])
    }
    
    func didSelectItem(item: CharactersListItemViewModel) {
        let characters = self.pages.characters
        if let one = characters.first(where: { $0.id == item.id}) {
            actions?.showCharacterDetails(one)
        }
    }
    
    func markFavorite(character: MarvelCharacter) {
        repository.favorite(character: character) { result in
            if case let .failure(error) = result {
                self.handleError(error)
            } else {
                // 좋아요 마크
                let news = self._items.value
                if let index = news.firstIndex(where: { $0.id == character.id }) {
                    news[index].markFavorite(true, at: Date())
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
                let news = self._items.value
                if let index = news.firstIndex(where: { $0.id == character.id }) {
                    news[index].markFavorite(false, at: nil)
                    self._items.send(news)
                }
            }
        }
        .store(in: &cancellabels)
    }
    
    // out -
    
    var emtpyLabelText: String {
        "데이터가 없어요."
    }
    
    var items: AnyPublisher<[CharactersListItemViewModel], Never> {
        _items.eraseToAnyPublisher()
    }
    
    var itemsIsEmpty: Bool {
        _items.value.isEmpty
    }
    
    var itemsAllLoaded: AnyPublisher<Bool, Never> {
        _itemsAllLoaded.eraseToAnyPublisher()
    }
    
    var loadings: AnyPublisher<ListLoading, Never> {
        _loading.eraseToAnyPublisher()
    }
    
    
}
