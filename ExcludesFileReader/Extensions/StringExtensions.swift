//
//  StringExtensions.swift
//  ExcludesFileReader
//
//  Created by Alex Culeva on 1/12/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

extension String {
    static let empty = ""
    static let allFiles = "/*"
    static let anyCombination = ".*"
    static let slash = "/"
    static let tilde = "~"
    static let currentDirectory = "."
    static let parentDirectory = ".."
    static let recursive = "*"
    static let ignoredPathPrefix = "**"
    static let yml = "yml"

    var lines: [String] {
        return components(separatedBy: .newlines)
    }

    var NSString: NSString {
        return self as NSString
    }

    var firstQuotedSubstring: String {
        do {
            let regex = try NSRegularExpression(pattern: "“([^”]*)”|\"([^\"]*)\"", options: [])
            let range = regex.rangeOfFirstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count))
            guard range.length > 2 else { return .empty }
            return NSString.substring(with: NSRange(location: range.location + 1, length: range.length - 2))
        } catch _ {
            return .empty
        }
    }
}
