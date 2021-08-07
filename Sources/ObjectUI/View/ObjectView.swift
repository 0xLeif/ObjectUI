//
//  ObjectView.swift
//  ObjectUI
//
//  Created by Leif on 5/24/21.
//

import SwiftUI

public struct ObjectView<Content>: View where Content: View {
    @ObservedObject private var object: Object
    
    private let content: (Object) -> Content
    
    public init(
        data: Any? = nil,
        @ViewBuilder content: @escaping (Object) -> Content
    ) {
        self.object = Object(data)
        self.content = content
    }
    
    public var body: some View {
        content(object)
    }
}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectView(data: "Hello, World 👋") { object in
            if let text = object.value(as: String.self) {
                Text(text)
            } else {
                ProgressView()
                    
            }
        }
    }
}
