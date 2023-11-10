//
//  MockCharacterDetailViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import Foundation
import Combine
import Shared

final public class MockCharacterDetailViewModel: BaseViewModel, CharacterDetailViewModel {
    
    public override init() {
        _stateChanges = CurrentValueSubject<DetailViewState, Never>(DetailViewState.convertState(from: character))
    }
    
    public var characterName: String {
        "gagga"
    }
    
    private var _stateChanges: CurrentValueSubject<DetailViewState, Never>!
    
    public var stateChanges: AnyPublisher<DetailViewState, Never> {
        _stateChanges.eraseToAnyPublisher()
    }
    
    public var state: DetailViewState {
        _stateChanges.value
    }
    
    
    public func toggleFavorited() {
        
    }
    
    let character = MarvelCharacter(id: 10,
                                    name: "hello",
                                    description: "yamyam",
                                    resourceURI: nil,
                                    urls: [
                                        MarvelUrl(type: "detail",
                                                  url: "http://marvel.com/characters/105/aginar?utm_campaign=apiRef&utm_source=f26d94ddbc3fbf14d9520a614e2cc9e2"),
                                        MarvelUrl(type: "wiki",
                                                  url: "http://marvel.com/universe/Aginar?utm_campaign=apiRef&utm_source=f26d94ddbc3fbf14d9520a614e2cc9e2")
                                    ],
                                    thumbnail: URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"),
                                    comics: MarvelResourceList(
                                        availableCount: 10,
                                        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011136/comics"),
                                    stories: MarvelResourceList(
                                        availableCount: 10,
                                        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011136/stories"),
                                    events: MarvelResourceList(
                                        availableCount: 10,
                                        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011136/events"),
                                    series: MarvelResourceList(
                                        availableCount: 10,
                                        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011136/series"))
}
