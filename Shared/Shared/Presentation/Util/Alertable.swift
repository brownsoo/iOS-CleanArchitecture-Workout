//
//  Alertable.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

public protocol Alertable {}

public extension Alertable where Self: UIViewController {
    func showAlert(
        title: String = "",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
