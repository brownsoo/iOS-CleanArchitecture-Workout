//
//  CharacterDetailVc.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Combine

final class CharacterDetailVc: UIViewController {
    static func create(viewModel: CharacterDetailViewModel) -> CharacterDetailVc {
        let vc = CharacterDetailVc()
        vc.viewModel = viewModel
        return vc
    }
    
    private var viewModel: CharacterDetailViewModel?
    private var cancellables: Set<AnyCancellable> = []
}
