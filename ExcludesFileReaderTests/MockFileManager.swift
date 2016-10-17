//
//  MockFileManager.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Foundation
@testable import ExcludesFileReader

class MockFileManager: FileManager {
    
    func testFile(_ fileName: String, fileType: String) -> String {
        let testBundle = Bundle(for: type(of: self))
        
        return testBundle.path(forResource: fileName, ofType: fileType)!
    }
    
    override func subpathsOfDirectory(atPath path: String) throws -> [String] {
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
        
        throw CommandLineError.cannotReadFromHelpFile
    }
}
