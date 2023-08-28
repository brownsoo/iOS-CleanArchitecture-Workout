//
//  CharactersListViewController.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/24.
//

import UIKit

class CharactersListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        let label = UILabel()
        label.text = "hi"
        label.textColor = UIColor.black
        self.view.addSubview(label)
        label.makeConstraints { v in
            v.edgesConstraintTo(view.safeAreaLayoutGuide ,edges: [.top, .leading])
        }
    }
}

