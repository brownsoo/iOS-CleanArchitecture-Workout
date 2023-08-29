//
//  LoadingView.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

class LoadingView {

    static var spinner: UIActivityIndicatorView?

    static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            
            if spinner == nil,
               let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first {
                let frame = UIScreen.main.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                spinner.style = .large
                window.addSubview(spinner)

                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }

    static func hide(didHide: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinner = nil
            didHide?()
        }
    }

    @objc static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide {
                    show()
                }
            }
        }
    }
}

