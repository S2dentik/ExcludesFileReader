//
//  MockFileManager.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Foundation
@testable import ExcludesFileReader

class MockFileManager: NSFileManager {
    
    func testFile(fileName: String, fileType: String) -> String {
        let testBundle = NSBundle(forClass: self.dynamicType)
        
        return testBundle.pathForResource(fileName, ofType: fileType)!
    }
    
    override func subpathsOfDirectoryAtPath(path: String) throws -> [String] {
        if path == "/root" {
            return ["project/file1.txt",
                    "project/file2.txt",
                    "project/folder/file1_1.txt",
                    "project/folder/file1_2.txt",
                    "project/file3.txt",
                    "project/folderTests/testfile.txt",
                    "project/folderTests/testfile2.txt" ,
                    "project/file.txt"]
        }
        
        throw CommandLineError.CannotReadFromHelpFile
    }
}
