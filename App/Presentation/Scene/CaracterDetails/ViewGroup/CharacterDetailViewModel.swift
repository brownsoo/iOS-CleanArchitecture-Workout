//
//  CharacterDetailViewModel.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
//

import Foundation
import Combine

struct CharacterDetailViewModelActions {
    
}

protocol CharacterDetailViewModel: ViewModel {
    // out
    var characterChanges: AnyPublisher<MarvelCharacter, Never> { get }
    // in
    func toggleFavorited(characterId: Int) -> Void
}

final class DefaultCharacterDetailViewModel: BaseViewModel {
    private let actions: CharacterDetailViewModelActions?
    private let repository: CharactersRepository
    private let _characterChanges: CurrentValueSubject<MarvelCharacter, Never>
    
    init(character: MarvelCharacter,
         actions: CharacterDetailViewModelActions,
         repository: CharactersRepository) {
        self.actions = actions
        self.repository = repository
        self._characterChanges = CurrentValueSubject<MarvelCharacter, Never>(character)
    }
    
    
    private func markFavorite() {
        var data = _characterChanges.value
        repository.favorite(character: data) { result in
            if case let .failure(error) = result {
                self.handleError(error)
            } else {
                data.isFavorite = true
                data.favoritedAt = Date()
                self._characterChanges.send(data)
            }
        }
        .store(in: &cancellabels)
    }
    
    private func unmarkFavorte() {
        var data = _characterChanges.value
        repository.unfavorite(character: data) { result in
            if case let .failure(error) = result {
                self.handleError(error)
            } else {
                data.isFavorite = false
                data.favoritedAt = nil
                self._characterChanges.send(data)
            }
        }
        .store(in: &cancellabels)
    }
}


extension DefaultCharacterDetailViewModel: CharacterDetailViewModel {
    // out
    var characterChanges: AnyPublisher<MarvelCharacter, Never> {
        _characterChanges.eraseToAnyPublisher()
    }
    // in
    func toggleFavorited(characterId: Int) {
        let bool = _characterChanges.value.isFavorite == true
        if bool {
            unmarkFavorte()
        } else {
            markFavorite()
        }
    }
}
