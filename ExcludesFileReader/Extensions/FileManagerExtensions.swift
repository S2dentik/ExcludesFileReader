//
//  FileManagerExtensions.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Foundation

extension FileManager {
    func isDirectory(_ path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        fileExists(atPath: path, isDirectory: &isDirectory)
        
        return isDirectory.boolValue
    }
}
