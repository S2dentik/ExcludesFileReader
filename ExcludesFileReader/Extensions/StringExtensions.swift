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
        return rawExcludePath.substringBetween("“", "”")
            ?? rawExcludePath.substringBetween("\"", "\"")
            ?? rawExcludePath.substringBetween("'", "'")
            ?? rawExcludePath
    }

    func substringBetween(_ prefix: String, _ suffix: String) -> String? {
        return isSurroundedBy(prefix, suffix) ? String(dropFirst().dropLast()) : nil
    }

    func isSurroundedBy(_ prefix: String, _ suffix: String) -> Bool {
        return hasPrefix(prefix) && hasSuffix(suffix)
    }
}
