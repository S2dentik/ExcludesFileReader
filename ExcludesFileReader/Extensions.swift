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
    
    var firstQuotedSubstring: String {
        do {
            let regex = try NSRegularExpression(pattern: "“([^”]*)”|\"([^\"]*)\"", options: [])
            let range = regex.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            guard range.length > 2 else {
                return String.Empty
            }
            
            return (self as NSString).substring(with: NSMakeRange(range.location + 1, range.length - 2))
        } catch _ {
            return String.Empty
        }
    }
}

extension FileManager {
    func isDirectory(_ path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        self.fileExists(atPath: path, isDirectory: &isDirectory)
        
        return isDirectory.boolValue
    }
}
