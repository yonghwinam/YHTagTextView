# YHTagTextView

`YHTagTextView` is a custom SwiftUI view that automatically detects hashtags (`#`) and user tags (`@`) in a string, converting them into tappable links. When a hashtag or user tag is tapped, a specified callback function is triggered, allowing you to handle the event as needed.

## Features

- Automatically detects hashtags (`"#example"`) and user tags (`"@user"`) within a string.
- Tappable tags that trigger specified callback functions.
- Customizable tag color.
- Easy-to-use API for quick integration.

## Requirements

- **iOS 15.0** or later
- **Swift 5.0** or later
- **SwiftUI**

## Installation

### Swift Package Manager

1. In Xcode, go to `File > Swift Packages > Add Package Dependency...`.
2. Enter the following URL and click "Next":
`https://github.com/YourUsername/YHTagTextView.git`   
3. Set the version rules, click "Next," then select the target you want to add the package to, and click "Finish."

## Usage

```swift
import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            YHTagTextView(
                string: "Check out #SwiftUI and connect with @JohnDoe for more details!",
                tagColor: .blue,
                touchedHashTag: { hashtag in
                    alertMessage = "You tapped on the hashtag: \(hashtag)"
                    showAlert = true
                },
                touchedUserTag: { usertag in
                    alertMessage = "You tapped on the user tag: \(usertag)"
                    showAlert = true
                })
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Tag Selected"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
