//
//  UIViewPreview.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
//

import SwiftUI

struct UIViewPreview<V: UIView>: UIViewRepresentable {
    let builder: () -> V
    init(_ builder: @escaping () -> V) {
        self.builder = builder
    }
    
    func makeUIView(context: Context) -> some UIView {
        return builder()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
