/// The Swift Programming Language
/// https:///docs.swift.org/swift-book

import SwiftUI

public struct YHTagTextView: View {
    
    /// The text to be displayed, which may contain hashtags or user tags.
    private var string: String?
    
    /// The color to be applied to hashtags and user tags.
    private var tagColor: Color? = nil
    
    /// Callback to handle when a hashtag is touched.
    private var touchedHashTag: ((String) -> Void)? = nil
    
    /// Callback to handle when a user tag is touched.
    private var touchedUserTag: ((String) -> Void)? = nil
    
    /// Public initializer to set up the view with optional text, tag color, and callbacks.
    public init(string: String? = nil,
                tagColor: Color? = nil,
                touchedHashTag: ((String) -> Void)? = nil,
                touchedUserTag: ((String) -> Void)? = nil) {
        
        self.string = string
        self.tagColor = tagColor
        self.touchedHashTag = touchedHashTag
        self.touchedUserTag = touchedUserTag
    }
    
    public var body: some View {
        /// If the string is not nil, display the text with links.
        if string != nil {
            Text(convertToTagStrings(self.string))
                .environment(\.openURL, OpenURLAction(handler: { url in
                    let tagWord = tagword(of: url)
                    
                    /// If the touched tag is a hashtag, execute the hashtag callback.
                    if tagWord.hasPrefix("#") && self.touchedHashTag != nil {
                        self.touchedHashTag!(tagWord)
                    }
                    
                    /// If the touched tag is a user tag, execute the user tag callback.
                    if tagWord.hasPrefix("@") && self.touchedUserTag != nil {
                        self.touchedUserTag!(tagWord)
                    }
                    
                    return .handled
                }))
        } else {
            /// If the string is nil, display an empty view.
            EmptyView()
        }
        
    }
    
    // MARK: - Private Functions
    
    /// Converts the provided string into an AttributedString, applying links and optional color to hashtags and user tags.
    private func convertToTagStrings(_ string: String?) -> AttributedString {
        guard let desc = string else { return AttributedString("") }
        
        var attrStrings = AttributedString(desc)
        
        /// Regular expression to find hashtags or user tags.
        let regx = try? NSRegularExpression(pattern: "[#@][^\\s#@]+")
    
        /// Find all matches of the regular expression in the string.
        let matches = regx?.matches(in: desc, range: NSMakeRange(0, desc.utf16.count))
        
        for matchResult in matches! {
            let matchRange = matchResult.range
            if let range = Range(matchRange, in: desc) {
                let tagWord = desc[range]
                if let attrRange = attributedRange(matchRange, in: desc) {
                    /// Apply a link to the tag word.
                    attrStrings[attrRange].link = URL(string: "select:///tag?\(tagWord.addingPercentEncoding(withAllowedCharacters: .letters)!)")
                    
                    /// Apply the optional tag color if provided.
                    if self.tagColor != nil {
                        attrStrings[attrRange].foregroundColor = self.tagColor!
                    }
                    
                } else {
                    /// Log an error if the attributed range cannot be created.
                    debugPrint("❌ Failed to create attributed range for tag: \(tagWord)")
                }
            }
            
        }
        
        return attrStrings
    }
    
    /// Converts an NSRange to a Range<AttributedString.Index>.
    private func attributedRange(_ nsRange: NSRange, in string:String ) -> Range<AttributedString.Index>? {
        let attrString = AttributedString(string)
        
        guard let startIndex = AttributedString.Index(String.Index(utf16Offset: nsRange.location, in: string), within: attrString) else { return nil}
        guard let endIndex = AttributedString.Index(String.Index(utf16Offset: nsRange.location + nsRange.length, in: string), within: attrString) else { return nil}
        
        return startIndex..<endIndex
    }
    
    /// Extracts the tag word from the given URL.
    private func tagword(of url: URL) -> String {
        if #available(iOS 16.0, *) {
            let word = url.query()!.removingPercentEncoding!
            
            return word
        } else {
            /// Fallback on earlier versions
            let word = url.query!.removingPercentEncoding!
            
            return word
        }
    }
}

