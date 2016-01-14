//
//  ExcludesFileReader.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Cocoa

final public class ExcludesFileReader {
    let fileManager: NSFileManager
    let ExcludesFileExtension = ".yml"
    let StartPathSymbol: Character = "“"
    let EndPathSymbol: Character = "”"
    let PossibleStartAndEndSymbol: Character = "\""
    
    public init(fileManager: NSFileManager = NSFileManager.defaultManager()) {
        self.fileManager = fileManager
    }
    
    public func absolutePathsFromExcludesFile(excludesFilePath: String, forAnalyzePath analyzePath: String) throws -> [String] {
        do {
            try validateExcludesFilePath(excludesFilePath)
        } catch CommandLineError.ExcludesFileError(let errorMessage) {
            throw CommandLineError.ExcludesFileError(errorMessage)
        } catch _ {
            return []
        }
        do {
            let contentsOfFile = try String(contentsOfFile: excludesFilePath)
            let excludes = excludesFromContentsOfFile(contentsOfFile, analyzePath: analyzePath)
            let paths = excludesPathsWhereContainsRelativeNames(analyzePath, relativePaths: excludes.relativePaths)
            return paths + excludes.absolutePaths
        } catch {
            throw CommandLineError.ExcludesFileError("\nCan't read from indicated excludes file")
        }
    }
    
    private func validateExcludesFilePath(path: Path) throws {
        guard fileManager.fileExistsAtPath(path) else {
            throw CommandLineError.ExcludesFileError("\nIndicated excludes file does not exist")
        }
        if fileManager.isDirectory(path) { throw CommandLineError.ExcludesFileError("\nDirectory was indicated as excludes file") }
        guard path.hasSuffix(ExcludesFileExtension) else {
            throw CommandLineError.ExcludesFileError("\nExcludes file must have .yml extension")
        }
    }
    
    private func excludesFromContentsOfFile(contents: String, analyzePath: String) -> Excludes {
        let paths = contents.lines.map { $0.firstQuotedSubstring }
            .filter { !$0.isIgnoredType }
            .reduce([String]()) { $0 + $1.formattedExcludePath(analyzePath) }
        
        return Excludes(paths: paths)
    }
    
    private func excludesPathsWhereContainsRelativeNames(rootPath: Path, relativePaths: [Path]) -> [Path] {
        let paths = subpathsOfDirectoryAtPath(rootPath)
        
        return paths.filter { $0.containingAnyDirectories(relativePaths) }.map { $0.absolutePath(rootPath) }
    }
    
    private func subpathsOfDirectoryAtPath(path: String) -> [Path] {
        do {
            return try fileManager.subpathsOfDirectoryAtPath(path)
        } catch _ { return [] }
    }
}
