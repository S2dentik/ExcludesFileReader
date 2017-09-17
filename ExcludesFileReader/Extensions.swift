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

extension FileManager {
    func isDirectory(_ path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        self.fileExists(atPath: path, isDirectory: &isDirectory)
        
        return isDirectory.boolValue
    }
}
