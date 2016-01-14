//
//  Excludes.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 1/12/16.
//  Copyright © 2016 YOPESO. All rights reserved.
//

import Foundation

final class Excludes {
    let excludePaths: [Path]
    
    lazy var absolutePaths: [Path] = {
        return self.excludePaths.filter { $0.hasPrefix(DirectorySuffix.Slash.rawValue) }
    }()
    
    lazy var relativePaths: [String] = {
        return self.excludePaths.filter { !$0.hasPrefix(DirectorySuffix.Slash.rawValue) &&
            !$0.hasSuffix(DirectorySuffix.AnyCombination.rawValue) &&
            !$0.hasPrefix(DirectorySuffix.AnyCombination.rawValue)}
    }()
    
    init(paths: [Path]) {
        self.excludePaths = paths.deleteSuffixes()
    }
}
