//
//  CharacterDetailViewModel.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
//

import Foundation
import Combine
import Shared

public struct CharacterDetailViewModelActions {
    public init() {}
}

public protocol CharacterDetailViewModel: ViewModel {
    // out
    var characterName: String { get }
    var stateChanges: AnyPublisher<DetailViewState, Never> { get }
    var state: DetailViewState { get }
    // in
    func toggleFavorited(characterId: Int) -> Void
}

public struct DetailViewState: Equatable {
    var title: String
    var thumbnail: URL?
    var isFavorite: Bool
    var url: URL?
    
    
    static func convertState(from character: MarvelCharacter) -> DetailViewState {
        DetailViewState(title: character.name,
                        thumbnail: character.thumbnail,
                        isFavorite: character.isFavorite == true,
                        url: (character.urls.first(where: { $0.type.starts(with: "wiki") })?.url ?? character.urls.first?.url)?.toURL()
        )
    }
}

public class DefaultCharacterDetailViewModel: BaseViewModel {
    private let actions: CharacterDetailViewModelActions?
    private let repository: CharactersRepository
    private var character: MarvelCharacter
    private var _stateChanges: CurrentValueSubject<DetailViewState, Never>!
    
    public init(character: MarvelCharacter,
         actions: CharacterDetailViewModelActions,
         repository: CharactersRepository) {
        self.character = character
        self.actions = actions
        self.repository = repository
        self._stateChanges = CurrentValueSubject<DetailViewState, Never>(DetailViewState.convertState(from: character))
    }
    
    
    private func markFavorite() {
        repository.favorite(character: self.character) { [weak self] result in
            guard let this = self else { return }
            switch result {
                case .failure(let error):
                    this.handleError(error)
                case .success(_):
                    this.character.isFavorite = true
                    this.character.favoritedAt = Date()
                    this._stateChanges.send(DetailViewState.convertState(from: this.character))
            }
        }
        .store(in: &cancellabels)
    }
    
    private func unmarkFavorte() {
        repository.unfavorite(character: self.character) { [weak self] result in
            guard let this = self else { return }
            switch result {
                case .failure(let error):
                    this.handleError(error)
                case .success(_):
                    this.character.isFavorite = false
                    this.character.favoritedAt = nil
                    this._stateChanges.send(DetailViewState.convertState(from: this.character))
            }
        }
        .store(in: &cancellabels)
    }
}


extension DefaultCharacterDetailViewModel: CharacterDetailViewModel {
    // out
    public var characterName: String {
        self.character.name
    }
    public var stateChanges: AnyPublisher<DetailViewState, Never> {
        _stateChanges.eraseToAnyPublisher()
    }
    
    public var state: DetailViewState {
        _stateChanges.value
    }
    // in
    public func toggleFavorited(characterId: Int) {
        let bool = _stateChanges.value.isFavorite == true
        if bool {
            unmarkFavorte()
        } else {
            markFavorite()
        }
    }
}
