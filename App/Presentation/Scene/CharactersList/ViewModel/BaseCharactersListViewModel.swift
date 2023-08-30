//
//  BaseCharactersListViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import Foundation
import Combine

/// CharactersListViewModel 의 공통 구현체
class BaseCharactersListViewModel: BaseViewModel {
    
    internal var actions: CharactersListViewModelActions?
    internal var repository: CharactersRepository
    
    internal var currentPage: Int = 0
    internal var naxtPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var totalPages: Int = 0
    private var hasMorePages: Bool { currentPage < totalPages }
    
    private var pages: [PagedData<MarvelCharacter>] = []
    internal var loadTask: Cancellable? {
        willSet {
            loadTask?.cancel()
        }
    }
    internal let maingQueue = DispatchQueue.main
    internal let _itemsAllLoaded = PassthroughSubject<Bool, Never>()
    internal let _items = CurrentValueSubject<[CharactersListItemViewModel], Never>([])
    internal let _loading = CurrentValueSubject<ListLoading, Never>(.idle)
    
    init(actions: CharactersListViewModelActions,
         characterRepository: CharactersRepository) {
        self.actions = actions
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
        pages = pages.filter({ $0.page != newPage.page }) + [newPage]
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
        actions?.showCharacterDetails(pages.characters[index])
    }
    func didSelectItem(characterId: Int) {
        let characters = self.pages.characters
        if let one = characters.first(where: { $0.id == characterId }) {
            actions?.showCharacterDetails(one)
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
