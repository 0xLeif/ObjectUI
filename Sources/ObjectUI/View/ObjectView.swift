//
//  ObjectView.swift
//  ObjectUI
//
//  Created by Leif on 5/24/21.
//

import SwiftUI

public struct ObjectView<Content>: View where Content: View {
    @ObservedObject private var object: Object
    
    private var content: (Object) -> Content
    
    public init(
        data: Any? = nil,
        content: @escaping (Object) -> Content
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
            object.value(as: String.self).map { message in
                Text(message)
            }
        }
    }
}
