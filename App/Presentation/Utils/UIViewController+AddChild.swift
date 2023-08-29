//
//  UIViewController+AddChild.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

extension UIViewController {
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSelf() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
