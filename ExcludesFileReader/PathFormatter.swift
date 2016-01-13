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
        let pathComponents = self.componentsSeparatedByString(DirectorySuffix.Slash.rawValue)
        return pathComponents.last!
    }
    
    func absolutePath(analyzePath: String = NSFileManager.defaultManager().currentDirectoryPath) -> Path {
        if self.hasPrefix(DirectorySuffix.TildeSymbol.rawValue) { return NSHomeDirectory() + self.stringByReplacingOccurrencesOfString(DirectorySuffix.TildeSymbol.rawValue, withString: String.Empty) }
        if self.hasPrefix(DirectorySuffix.Slash.rawValue) { return self }
        let concatenatedPaths = analyzePath + DirectorySuffix.Slash.rawValue + self
        
        return concatenatedPaths.editAbsolutePath()
    }
    
    func formattedExcludePath(analyzePath: String = NSFileManager.defaultManager().currentDirectoryPath) -> Path {
        if self.hasPrefix(DirectorySuffix.AnyCombination.rawValue) && self.hasSuffix(DirectorySuffix.AnyCombination.rawValue) { return self }
        if containsSymbolAsPrefixOrSuffix(DirectorySuffix.AnyCombination.rawValue) { return String.Empty }
        
        return self.absolutePath(analyzePath)
    }
    
    private func containsSymbolAsPrefixOrSuffix(symbol: String) -> Bool {
        return (self.hasPrefix(symbol) && !self.hasSuffix(symbol)) || (!self.hasPrefix(symbol) && self.hasSuffix(symbol))
    }
    
    private func editAbsolutePath() -> Path {
        var pathComponents = self.componentsSeparatedByString(DirectorySuffix.Slash.rawValue)
        editPathComponentsForDotShortcuts(&pathComponents)
        checkLastPathComponentsElement(&pathComponents)
        
        return pathComponents.joinWithSeparator(DirectorySuffix.Slash.rawValue)
    }
    
    private func editPathComponentsForDotShortcuts(inout pathComponents: [String]) {
        for (index, element) in pathComponents.enumerate() {
            if element == DirectorySuffix.CurrentDirectorySymbol.rawValue {
                pathComponents.removeAtIndex(index)
            }
            if element == DirectorySuffix.ParentDirectorySymbol.rawValue {
                pathComponents.removeAtIndex(index)
                pathComponents.removeAtIndex(index - 1)
            }
        }
    }
    
    private func checkLastPathComponentsElement(inout pathComponents: [String]) {
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
                modifiedString = modifiedString.stringByReplacingOccurrencesOfString(DirectorySuffix.AnyCombination.rawValue, withString: String.Empty)
        }
        
        return modifiedString
    }
    
    func deleteSuffix(suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        
        return (self as NSString).substringToIndex(self.characters.count - suffix.characters.count)
    }
    
    func hasDirectory(named name: String) -> Bool {
        return self.lowercaseString.rangeOfString(name.lowercaseString) != nil
    }
    
    func containingAnyDirectories(directories: [Path]) -> Bool {
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

extension SequenceType where Generator.Element == Path {
    
    func deleteSuffixes() -> [Path] {
        return self.map { $0.deleteSuffixes() }
    }
}
