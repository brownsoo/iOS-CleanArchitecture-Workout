//
//  UIViewController+AddChild.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

extension UIViewController {
    func add(childVc: UIViewController, container: UIView) {
        addChild(childVc)
        childVc.view.frame = container.bounds
        container.addSubview(childVc.view)
        childVc.didMove(toParent: self)
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
