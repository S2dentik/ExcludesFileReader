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
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
    
    var firstQuotedSubstring: String {
        do {
            let regex = try NSRegularExpression(pattern: "“([^”]*)”|\"([^\"]*)\"", options: [])
            let range = regex.rangeOfFirstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count))
            guard range.length > 2 else {
                return String.Empty
            }
            
            return (self as NSString).substringWithRange(NSMakeRange(range.location + 1, range.length - 2))
        } catch _ {
            return String.Empty
        }
    }
}

extension NSFileManager {
    func isDirectory(path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        self.fileExistsAtPath(path, isDirectory: &isDirectory)
        
        return isDirectory.boolValue
    }
}
