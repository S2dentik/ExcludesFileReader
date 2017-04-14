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
        return self.excludePaths.filter { $0.hasPrefix(.slash) }
    }()
    
    lazy var relativePaths: [String] = {
        return self.excludePaths.filter {
            !$0.hasPrefix(.slash) &&
            !$0.hasSuffix(.anyCombination) &&
            !$0.hasPrefix(.anyCombination)
        }
    }()
    
    init(paths: [Path]) {
        self.excludePaths = paths.deletingSuffixes()
    }
}
