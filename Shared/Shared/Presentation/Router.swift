//
//  Router.swift
//  Shared
//
//  Created by hyonsoo on 11/10/23.
//

import Foundation

public enum RouteTransition {
    case push
    case cover
}

public enum Destination {
    case favorites
    case characterDetail(character: MarvelCharacter)
}

public class Router {
    
    public static var routeResolver: ((Destination, RouteTransition, Bool) -> Void)?
    
    public static func route(_ dest: Destination,
                             transition: RouteTransition = .push,
                             animating: Bool = true
    ) {
        routeResolver?(dest, transition, animating)
    }
}
