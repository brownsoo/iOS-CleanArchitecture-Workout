//
//  UIViewControllerPreview.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import SwiftUI

struct UIViewControllerPreview<U: UIViewController>: UIViewControllerRepresentable {
    
    let builder: () -> U
    
    init(_ builder: @escaping () -> U) {
        self.builder = builder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return builder()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
}
