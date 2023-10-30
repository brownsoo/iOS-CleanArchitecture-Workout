//
//  DefaultCharactersListViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import Foundation
import Combine
import Shared

final class DefaultCharactersListViewModel: BaseCharactersListViewModel {
    
    override func load(loading: ListLoading,
                       refreshing: Bool = false,
                       isCurrentPage: Bool = false) {
        _loading.send(loading)
        loadTask = repository.fetchList(
            page: isCurrentPage ? currentPage : naxtPage,
            refreshing: refreshing,
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
                            if let e = error.asNetworkError,
                               case NetworkError.contentNotChanged = e {
                                // not changed
                            } else {
                                self?.handleError(error)
                            }
                    }
                    self?._loading.send(.idle)
                }
            })
    }
    
    override func actionOpenFavoritesList() {
        actions?.showFavorites()
    }
}
