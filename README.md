# ObjectUI

*Create SwiftUI Views with any data*

## Usage
```swift
import ObjectUI
```

### Basic Examples

#### ObjectView
```swift
struct ContentView: View {
    var body: some View {
        ObjectView(data: "Hello, World 👋") { object in
            if let text = object.value(as: String.self) {
                Text(text)
            } else {
                ProgressView()
            }
        }
    }
}
```

#### StateObjectView
```swift
struct ContentView: View {
    var body: some View {
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
```

### JSON Example
```swift
struct ContentView: View {
    let json = """
        {
          "userId": 1,
          "id": 2,
          "title": "quis ut nam facilis et officia qui",
          "completed": false
        }
        """
        .data(using: .utf8)
    
    var body: some View {
        ObjectView(data: json) { object in
            VStack {
                object.userId.value(as: Int.self).map { userId in
                    Text("\(userId)")
                }
                
                object.id.value(as: Int.self).map { id in
                    Text("\(id)")
                }
                
                object.title.value(as: String.self).map { title in
                    Text(title)
                }
                
                object.completed.value(as: Bool.self).map { completed in
                    Text(completed.description)
                }
            }
        }
    }
}
```
