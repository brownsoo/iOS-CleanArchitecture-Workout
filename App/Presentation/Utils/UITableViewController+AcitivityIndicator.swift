//
//  UITableViewController+AcitivityIndicator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

extension UITableViewController {
    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style = .medium
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)

        return activityIndicator
    }
}
