//
//  PathFormatter.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Cocoa

typealias Path = String

extension Path {
    
    func lastComponentFromPath() -> String {
        let pathComponents = self.components(separatedBy: DirectorySuffix.Slash.rawValue)
        return pathComponents.last!
    }
    
    func absolutePath(_ analyzePath: String = FileManager.default.currentDirectoryPath) -> Path {
        if self.hasPrefix(DirectorySuffix.TildeSymbol.rawValue) { return NSHomeDirectory() + self.replacingOccurrences(of: DirectorySuffix.TildeSymbol.rawValue, with: String.Empty) }
        if self.hasPrefix(DirectorySuffix.Slash.rawValue) { return self }
        let concatenatedPaths = analyzePath + DirectorySuffix.Slash.rawValue + self
        
        return concatenatedPaths.editAbsolutePath()
    }
    
    func formattedExcludePath(_ analyzePath: String = FileManager.default.currentDirectoryPath) -> Path {
        if self.hasPrefix(DirectorySuffix.AnyCombination.rawValue) && self.hasSuffix(DirectorySuffix.AnyCombination.rawValue) { return self }
        if containsSymbolAsPrefixOrSuffix(DirectorySuffix.AnyCombination.rawValue) { return String.Empty }
        
        return self.absolutePath(analyzePath)
    }
    
    fileprivate func containsSymbolAsPrefixOrSuffix(_ symbol: String) -> Bool {
        return (self.hasPrefix(symbol) && !self.hasSuffix(symbol)) || (!self.hasPrefix(symbol) && self.hasSuffix(symbol))
    }
    
    fileprivate func editAbsolutePath() -> Path {
        var pathComponents = self.components(separatedBy: DirectorySuffix.Slash.rawValue)
        editPathComponentsForDotShortcuts(&pathComponents)
        checkLastPathComponentsElement(&pathComponents)
        
        return pathComponents.joined(separator: DirectorySuffix.Slash.rawValue)
    }
    
    fileprivate func editPathComponentsForDotShortcuts(_ pathComponents: inout [String]) {
        for (index, element) in pathComponents.enumerated() {
            if element == DirectorySuffix.CurrentDirectorySymbol.rawValue {
                pathComponents.remove(at: index)
            }
            if element == DirectorySuffix.ParentDirectorySymbol.rawValue {
                pathComponents.remove(at: index)
                pathComponents.remove(at: index - 1)
            }
        }
    }
    
    fileprivate func checkLastPathComponentsElement(_ pathComponents: inout [String]) {
        if [String.Empty, DirectorySuffix.RecursiveSymbol.rawValue].contains(pathComponents.last!) {
            pathComponents.removeLast()
        }
    }
    
    var isIgnoredType: Bool {
        return self.hasPrefix(DirectorySuffix.IgnoredPathPrefix.rawValue) || self.isEmpty
    }
    
    func deleteSuffixes() -> Path {
        var modifiedString = self
        let suffixes = [DirectorySuffix.AllFiles.rawValue, DirectorySuffix.Slash.rawValue]
        for suffix in suffixes {
            modifiedString = modifiedString.deleteSuffix(suffix)
        }
        
        if modifiedString.hasSuffix(DirectorySuffix.AnyCombination.rawValue) &&
            modifiedString.hasPrefix(DirectorySuffix.AnyCombination.rawValue) {
                modifiedString = modifiedString.replacingOccurrences(of: DirectorySuffix.AnyCombination.rawValue, with: String.Empty)
        }
        
        return modifiedString
    }
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        
        return (self as NSString).substring(to: self.characters.count - suffix.characters.count)
    }
    
    func hasDirectory(named name: String) -> Bool {
        return self.lowercased().range(of: name.lowercased()) != nil
    }
    
    func containingAnyDirectories(_ directories: [Path]) -> Bool {
        for directoryName in directories {
            if self.hasDirectory(named: directoryName) {
                return true
            }
        }
        
        return false
    }
}

func +(lhs: [Path], rhs: Path) -> [Path] {
    return lhs + [rhs]
}

extension Sequence where Iterator.Element == Path {
    
    func deleteSuffixes() -> [Path] {
        return self.map { $0.deleteSuffixes() }
    }
}
