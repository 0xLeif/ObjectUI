# ObjectUI

*Create SwiftUI Views with any data*

## Usage
```swift
import ObjectUI
```

### Basic Example
```swift
struct ContentView: View {
    var body: some View {
        ObjectView { object in
            VStack {
                if let value = object.value(as: String.self) {
                    Text(value)
                        .font(.largeTitle)
                } else {
                    Text("Waiting...")
                }
                
                Button("Wave") {
                    DispatchQueue.main.async {
                        object.set(value: "👋")
                    }
                }
            }
        }
    }
}
```
