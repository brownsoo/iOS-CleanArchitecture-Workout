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
    
    static var comic: ComicApi = {
        ComicApi()
    }()
}

struct CharacterApi {
    func search(page: Int = 1, limit: Int = 20, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelCharacter>> {
        return NetworkResource(
            MarvelEndpoint("/v1/public/characters",
                           etag: etag,
                           parameters: ["offset" : (page - 1) * limit,
                                        "limit": limit])
        )
    }
    
    func get(characterId: Int, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelCharacter>> {
        return NetworkResource(
            MarvelEndpoint("/v1/public/characters/\(characterId)",
                           etag: etag)
        )
    }
    
    func searchComics(characterId: Int, page: Int = 1, limit: Int = 20, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelComic>> {
        return NetworkResource(
            MarvelEndpoint("/v1/public/characters/\(characterId)/comics",
                           etag: etag,
                           parameters: ["offset" : (page - 1) * limit,
                                        "limit": limit])
        )
    }
}


struct ComicApi {
    func get(comicId: Int, etag: String? = nil) -> NetworkResource<ResMarvelResults<ResMarvelComic>> {
        return NetworkResource(
            MarvelEndpoint("/v1/public/comics/\(comicId)", etag: etag)
        )
    }
}
