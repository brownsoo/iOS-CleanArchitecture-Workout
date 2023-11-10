//
//  BaseCharactersListViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import Foundation
import Combine
import Shared

/// CharactersListViewModel 의 공통 구현체
class BaseCharactersListViewModel: BaseViewModel {
    
    var repository: CharactersRepository
    var currentPage: Int = 0
    var naxtPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var totalPages: Int = 0
    private var hasMorePages: Bool { currentPage < totalPages }
    private var pages: [PagedData<MarvelCharacter>] = []
    
    var loadTask: Cancellable? {
        willSet {
            loadTask?.cancel()
        }
    }
    let maingQueue = DispatchQueue.main
    let _itemsAllLoaded = PassthroughSubject<Bool, Never>()
    let _items = CurrentValueSubject<[CharactersListItemViewModel], Never>([])
    let _loading = CurrentValueSubject<ListLoading, Never>(.idle)
    
    init(characterRepository: CharactersRepository) {
        self.repository = characterRepository
    }
    
    // MARK: implements to subclass
    internal func load(loading: ListLoading,
              refreshing: Bool = false,
              isCurrentPage: Bool = false) {
        debugPrint("서브 클래스에서 구현해야 해")
    }
    
    // MARK: implements to subclass
    internal func actionOpenFavoritesList() {
        debugPrint("서브 클래스에서 구현해야 해")
    }
    
    internal func appendPage(_ newPage: PagedData<MarvelCharacter>) {
        foot("page \(newPage.page) totalPages:\(newPage.totalPages)")
        currentPage = newPage.page
        totalPages = newPage.totalPages
        var pages = self.pages
        if let index = pages.firstIndex(where: { $0.page == newPage.page }) {
            pages[index] = newPage
        } else {
            pages.append(newPage)
        }
        self.pages = pages
        let characters = pages.characters
        _items.send(characters.map(CharactersListItemViewModel.init))
        _itemsAllLoaded.send(newPage.items.count < kQueryLimit && !characters.isEmpty)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPages = 1
        pages.removeAll()
        _items.send([])
    }
    
    private func markFavorite(character: MarvelCharacter) {
        foot()
        repository.favorite(character: character) { [weak self] result in
            if case let .failure(error) = result {
                self?.handleError(error)
            } else {
                self?.maingQueue.async {
                    self?.load(loading: .idle, isCurrentPage: true)
                }
            }
        }
        .store(in: &cancellabels)
    }
    
    private func unmarkFavorte(character: MarvelCharacter) {
        foot()
        repository.unfavorite(character: character) { [weak self] result in
            if case let .failure(error) = result {
                self?.handleError(error)
            } else {
                self?.maingQueue.async {
                    self?.load(loading: .idle, isCurrentPage: true)
                }
            }
        }
        .store(in: &cancellabels)
    }
}

extension BaseCharactersListViewModel: CharactersListViewModel {
    
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
    
    // in -
    
    func refresh(forced: Bool = false) {
        resetPages()
        load(loading: .first, refreshing: forced)
    }
    
    func loadNextPage() {
        foot("hasMorePages:\(hasMorePages), loading: \(_loading.value)")
        guard hasMorePages, _loading.value == .idle else { return }
        load(loading: .next)
    }
    
    func didSelectItem(at index: Int) {
        let character = pages.characters[index]
        Router.route?(.characterDetail(character: character))
    }
    func didSelectItem(characterId: Int) {
        let characters = self.pages.characters
        if let one = characters.first(where: { $0.id == characterId }) {
            Router.route?(.characterDetail(character: one))
        }
    }
    
    func toggleFavorited(characterId: Int) {
        let characters = self.pages.characters
        guard let character = characters.first(where: { $0.id == characterId }) else {
            // TODO: report cloud
            return
        }
        if character.isFavorite == true {
            unmarkFavorte(character: character)
        } else {
            markFavorite(character: character)
        }
    }
    
    func showFavoritesList() {
        actionOpenFavoritesList()
    }
}
