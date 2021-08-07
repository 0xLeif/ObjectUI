//
//  ObjectView.swift
//  ObjectUI
//
//  Created by Leif on 5/24/21.
//

import SwiftUI

public struct StateObjectView<Content>: View where Content: View {
    @StateObject private var object: Object = Object()
    
    private let content: (Object) -> Content
    
    public init(
        @ViewBuilder content: @escaping (Object) -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        content(object)
    }
}

struct StateObjectView_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectView { object in
            if let text = object.value(as: String.self) {
                Text(text)
            } else {
                ProgressView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            object.set(value: "👋")
                        }
                    }
            }
        }
    }
}
