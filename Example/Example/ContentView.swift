//
//  ContentView.swift
//  Example
//
//  Created by Yonghwi on 8/29/24.
//

import SwiftUI
import YHTagTextView

let description = "Swift is a powerful and intuitive programming language. @JaneDoe recommends using #SwiftLang to develop #iOS#iPadOS applications quickly and efficiently. With the latest version of Swift, you can create even more engaging user experiences by leveraging #Combine and #SwiftUI, as explained by @JohnSmith and @AliceJohnson. Developers share various tips and information in forums like #SwiftCommunity and #SwiftDevelopers, often collaborating with @SwiftExpert. In Arabic, you can explore the discussion with hashtags like #تطوير_سويفت (Swift Development) and #برمجة (Programming)."

struct ContentView: View {
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            YHTagTextView(
                string: description,
                tagColor: .blue,
                touchedHashTag: { hashtag in
                    debugPrint(hashtag)
                    alertMessage = "You tapped on the hashtag: \(hashtag)"
                    debugPrint(alertMessage)
                    showAlert.toggle()
                },
                touchedUserTag: { usertag in
                    alertMessage = "You tapped on the user tag: \(usertag)"
                    debugPrint(alertMessage)
                    showAlert.toggle()
                })
        }
        .padding()
        .alert(alertMessage, isPresented: $showAlert, actions: {})
    }
}

#Preview {
    ContentView()
}
