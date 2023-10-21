//
//  DefaultFavoritesListViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/30.
//

import Foundation
import Combine

final class DefaultFavoritesListViewModel: BaseCharactersListViewModel {
    
    override func load(loading: ListLoading,
                      refreshing: Bool = false,
                      isCurrentPage: Bool = false) {
        _loading.send(loading)
        loadTask = repository.getFavoriteList(
            page: isCurrentPage ? currentPage : naxtPage,
            onResult: { [weak self] result in
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
}
