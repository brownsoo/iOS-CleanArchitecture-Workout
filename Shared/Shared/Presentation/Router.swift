//
//  Router.swift
//  Shared
//
//  Created by hyonsoo on 11/10/23.
//

import Foundation

public enum Destination {
    case favorites
    case characterDetail(character: MarvelCharacter)
}

public class Router {
    public static var route: ((Destination)->Void)?
}
