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
    func search(page: Int = 1, limit: Int = 20, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelCharacter>> {
        return NetworkResource(
            MarvelEndpoint("/v1/public/characters",
                           etag: etag,
                           parameters: ["offset" : page * limit, "limit": limit])
        )
    }
    
    func get(characterId: Int, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelCharacter>> {
        return NetworkResource(
            MarvelEndpoint("/v1/public/characters/\(characterId)",
                           etag: etag)
        )
    }
    
    func searchComics(characterId: String, page: Int = 1, limit: Int = 20, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelComic>> {
        return self.searchComics(collectionURI: "/v1/public/characters/\(characterId)/comics", page: page, limit: limit)
    }
    
    func searchComics(collectionURI: String, page: Int = 1, limit: Int = 20) -> NetworkResource<ResMarvelResults<ResMarvelComic>> {
        return NetworkResource(
            MarvelEndpoint(collectionURI,
                           parameters: ["offset" : page * limit, "limit": limit])
        )
    }
}
