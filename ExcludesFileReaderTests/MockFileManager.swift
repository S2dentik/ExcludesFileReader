//
//  MockFileManager.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Foundation

class MockFileManager: NSFileManager {
    
    func testFile(fileName: String, fileType: String) -> String {
        let testBundle = NSBundle(forClass: self.dynamicType)
        
        return testBundle.pathForResource(fileName, ofType: fileType)!
    }
}