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

    var excludePath: String? {
        let rawExcludePath = String(dropFirst().trimmingCharacters(in: .whitespacesAndNewlines))
        let delimiters: [(start: String, end: String)] = [("“", "”"), ("\"", "\""), ("'", "'"), ("", "")]
        for (start, end) in delimiters {
            if rawExcludePath.hasPrefix(start) { return rawExcludePath.substringBetween(start, end) }
        }
        return nil
    }

    func substringBetween(_ prefix: String, _ suffix: String) -> String? {
        guard isSurroundedBy(prefix, suffix) else { return nil }
        let reversedWithoutPrefix = String(removingSubrange(startIndex..<prefix.endIndex).reversed())

        return String(reversedWithoutPrefix.removingSubrange(startIndex..<suffix.endIndex).reversed())
    }

    func isSurroundedBy(_ prefix: String, _ suffix: String) -> Bool {
        return hasPrefix(prefix) && hasSuffix(suffix)
    }

    func removingSubrange(_ bounds: Range<String.Index>) -> String {
        var melf = self
        melf.removeSubrange(bounds)

        return melf
    }
}
