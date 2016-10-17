//
//  ExcludesFileReader.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Cocoa

final public class ExcludesFileReader {
    let fileManager: FileManager
    let ExcludesFileExtension = ".yml"
    let StartPathSymbol: Character = "“"
    let EndPathSymbol: Character = "”"
    let PossibleStartAndEndSymbol: Character = "\""
    
    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func absolutePathsFromExcludesFile(_ excludesFilePath: String, forAnalyzePath analyzePath: String) throws -> [String] {
        do {
            try validateExcludesFilePath(excludesFilePath)
        } catch CommandLineError.excludesFileError(let errorMessage) {
            throw CommandLineError.excludesFileError(errorMessage)
        } catch _ {
            return []
        }
        do {
            let contentsOfFile = try String(contentsOfFile: excludesFilePath)
            let excludes = excludesFromContentsOfFile(contentsOfFile, analyzePath: analyzePath)
            let paths = excludesPathsWhereContainsRelativeNames(analyzePath, relativePaths: excludes.relativePaths)
            return paths + excludes.absolutePaths
        } catch {
            throw CommandLineError.excludesFileError("\nCan't read from indicated excludes file")
        }
    }
    
    fileprivate func validateExcludesFilePath(_ path: Path) throws {
        guard fileManager.fileExists(atPath: path) else {
            throw CommandLineError.excludesFileError("\nIndicated excludes file does not exist")
        }
        if fileManager.isDirectory(path) { throw CommandLineError.excludesFileError("\nDirectory was indicated as excludes file") }
        guard path.hasSuffix(ExcludesFileExtension) else {
            throw CommandLineError.excludesFileError("\nExcludes file must have .yml extension")
        }
    }
    
    fileprivate func excludesFromContentsOfFile(_ contents: String, analyzePath: String) -> Excludes {
        let paths = contents.lines.map { $0.firstQuotedSubstring }
            .filter { !$0.isIgnoredType }
            .reduce([String]()) { $0 + $1.formattedExcludePath(analyzePath) }
        
        return Excludes(paths: paths)
    }
    
    fileprivate func excludesPathsWhereContainsRelativeNames(_ rootPath: Path, relativePaths: [Path]) -> [Path] {
        let paths = subpathsOfDirectoryAtPath(rootPath)
        
        return paths.filter { $0.containingAnyDirectories(relativePaths) }.map { $0.absolutePath(rootPath) }
    }
    
    fileprivate func subpathsOfDirectoryAtPath(_ path: String) -> [Path] {
        do {
            return try fileManager.subpathsOfDirectory(atPath: path)
        } catch _ { return [] }
    }
}
