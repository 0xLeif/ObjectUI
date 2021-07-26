//
//  ObjectView.swift
//  ObjectUI
//
//  Created by Leif on 5/24/21.
//

import SwiftUI

public struct ObjectView<Content>: View where Content: View {
    @StateObject private var object: Object = Object()
    
    private var content: (Object) -> Content
    
    public init(
        data: Any? = nil,
        content: @escaping (Object) -> Content
    ) {
        self.content = content
        self.object.consume(Object(data))
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
