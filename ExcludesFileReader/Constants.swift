//
//  Constants.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 1/12/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

enum DirectorySuffix: String {
    case AllFiles = "/*"
    case AnyCombination = ".*"
    case Slash = "/"
    case TildeSymbol = "~"
    case CurrentDirectorySymbol = "."
    case ParentDirectorySymbol = ".."
    case RecursiveSymbol = "*"
    case IgnoredPathPrefix = "**"
}
