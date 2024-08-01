<p align="center">
<img src="https://lh3.googleusercontent.com/pw/AP1GczORxYQXRPtK0I2tZ2PJKMvJpnfE79c2Ta4UM1N3o7_LOmYoUpJW0OFsnUKewKYkXFA7gHzBww7mIPG3YuAyQ6JnLzArZaCITHDXCPnXcyqjVBHUb_Y=w1200" width="35%" alt="RxSwift Logo" />
</p>

# ReSwiftUI
ReSwiftUI is based on fulfillment of Redux component with SwiftUI and Combine.

## Requirements

iOS 14.0+ / SwiftUI

## Installation
### [Swift Package Manager](https://github.com/apple/swift-package-manager)

[Follow the guide from Apple Developer Documentation](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## Usage

### Create Store

Using `configureStore` to combine the reducers.

```swift
// AppDelegate.swift

import UIKit
import ReSwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ReSwiftUIStore.shared.configureStore(reducers: [FirstReducer()])
        
        return true
    }
}

```

### Defines your first reducer

* Prepares action type with enum string
* Implements the `ReSwiftUIReducer protocol`

Three attributes in Reducer
1. Name: Reducer's name
2. InitState: A part of state that reducer update
3. Process: A pure function to handle action.

```swift
// FirstReducer.swift

import ReSwiftUI

enum FirstActionType: String {
    case inputText
    case send
}

class FirstReducer: ReSwiftUIReducer {
    typealias T = FirstActionType
    let name: String = "first"
    
    var initState: [String : Any] = [
        "text": "",
        "isEditing": false
    ]
    
    func process<T>(state: [String : Any], action: ReSwiftUI.ReSwiftUIAction<T>) -> [String : Any] where T : RawRepresentable, T.RawValue == String {
        var newState = state
        switch action.type.rawValue {
        case FirstActionType.inputText.rawValue:
            newState["text"] = action.payload["text"]
            newState["isEditing"] = true
        case FirstActionType.send.rawValue:
            newState["text"] = ""
            newState["isEditing"] = false
        default:
            break
        }
        return newState
    }
    
}
```

### Use @ReSwiftUIPublished

Deines @ReSwiftUIPublished with reducer's name and key of state.

```swift
// ViewModel.swift

import ReSwiftUI

class ViewModel {
    @ReSwiftUIPublished var text: String?
    @ReSwiftUIPublished var isEditing: Bool?
    
    init() {
        _text = ReSwiftUIPublished(name: "first", key: "text")
        _isEditing = ReSwiftUIPublished(name: "first", key: "isEditing")
    }
    
}
```

Uses `onReceive` to change the state. 

It's a apporch to escaping `ObservableObject`, the detail is [here](https://medium.com/@stevenkuo_23676/state-management-in-swiftui-a1e5452f99c0#5208).


```swift
// ContentView.swift

import SwiftUI

struct ContentView: View {
    let vm = ViewModel()
    @State var text: String = ""
    var body: some View {
        VStack {
            Text(text)
        }
        .onReceive(vm.$text, perform: { value in
            self.text = value ?? ""
        })
    }
}
```

### Dispatch action

```swift
// ContentAction.swift

import ReSwiftUI

class ContentAction {
    static func inputText(text: String) {
        ReSwiftUIStore.shared.dispatch(action: ReSwiftUIDispatcher.createAction(FirstActionType.inputText)(["text": text]))
    }
}
```

```swift
// ContentView.swift

Button("dispatch") {
    ContentAction.inputText(text: "dispatch completed")
}
```