//
//  Extensions.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

extension String {
    static let Empty = ""
    
    var lines: [String] {
        return self.components(separatedBy: CharacterSet.newlines)
    }

    var excludePath: String? {
        guard let rawExcludePath = String(dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return nil
        }
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

extension FileManager {
    func isDirectory(_ path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        self.fileExists(atPath: path, isDirectory: &isDirectory)
        
        return isDirectory.boolValue
    }
}
