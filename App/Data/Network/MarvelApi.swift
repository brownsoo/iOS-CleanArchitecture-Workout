//
//  MarvelApi.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

class MarvelApi {
    static var character: CharacterApi = {
        CharacterApi()
    }()
}

struct CharacterApi {
    func search(page: Int = 1, limit: Int = 20) -> ApiResource<ResMarvelResults<ResMarvelCharacter>> {
        return ApiResource(
            MarvelEndpoint("/v1/public/characters",
                           parameters: ["offset" : page * limit, "limit": limit])
        )
    }
    
    func get(characterId: Int) -> ApiResource<ResMarvelResults<ResMarvelCharacter>> {
        return ApiResource(
            MarvelEndpoint("/v1/public/characters/\(characterId)")
        )
    }
    
    func searchComics(characterId: String, page: Int = 1, limit: Int = 20) -> ApiResource<ResMarvelResults<ResMarvelComic>> {
        return self.searchComics(collectionURI: "/v1/public/characters/\(characterId)/comics", page: page, limit: limit)
    }
    
    func searchComics(collectionURI: String, page: Int = 1, limit: Int = 20) -> ApiResource<ResMarvelResults<ResMarvelComic>> {
        return ApiResource(
            MarvelEndpoint(collectionURI,
                           parameters: ["offset" : page * limit, "limit": limit])
        )
    }
}
