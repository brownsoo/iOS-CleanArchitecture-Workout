//
//  UIViewControllerPreview.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import SwiftUI

public struct UIViewControllerPreview<U: UIViewController>: UIViewControllerRepresentable {
    
    let builder: () -> U
    
    public init(_ builder: @escaping () -> U) {
        self.builder = builder
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        return builder()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
}
