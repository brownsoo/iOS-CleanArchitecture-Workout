//
//  UIViewPreview.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
//

import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    init(_ builder: () -> View) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
