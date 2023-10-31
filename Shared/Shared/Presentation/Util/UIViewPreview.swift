//
//  UIViewPreview.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
//

import SwiftUI

public struct UIViewPreview<V: UIView>: UIViewRepresentable {
    let builder: () -> V
    public init(_ builder: @escaping () -> V) {
        self.builder = builder
    }
    
    public func makeUIView(context: Context) -> some UIView {
        return builder()
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
