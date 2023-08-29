//
//  FavoritesListVc.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

final class FavoritesListVc: UIViewController {
    static func create(viewModel: CharactersListViewModel) -> FavoritesListVc {
        let vc = FavoritesListVc()
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: CharactersListViewModel!
}
