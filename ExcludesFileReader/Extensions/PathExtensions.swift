//
//  PathExtensions.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

import Cocoa

typealias Path = String

private let currentDirectoryPath = FileManager.default.currentDirectoryPath

extension Path {

    var isIgnoredType: Bool {
        return hasPrefix(.ignoredPathPrefix) || isEmpty
    }

    func absolutePath(_ path: String = currentDirectoryPath) -> Path {
        if hasPrefix(.tilde) { return NSHomeDirectory() + replacingOccurrences(of: .tilde, with: .empty) }
        if hasPrefix(.slash) { return self }
        let concatenatedPath = path + .slash + self

        return concatenatedPath.polish()
    }

    func formattedExcludePath(_ path: String = currentDirectoryPath) -> Path {
        if hasPrefix(.anyCombination) && hasSuffix(.anyCombination) { return self }
        if containsSymbolAsPrefixOrSuffix(.anyCombination) { return .empty }

        return absolutePath(path)
    }

    fileprivate func containsSymbolAsPrefixOrSuffix(_ symbol: String) -> Bool {
        return hasPrefix(symbol) != hasSuffix(symbol)
    }

    fileprivate func polish() -> Path {
        var pathComponents = components(separatedBy: .slash)
        pathComponents.enumerated().map { index, element -> [Int] in
            if element == .currentDirectory { return [index] }
            if element == .parentDirectory { return [index, index - 1] }
            return []
        }.flatMap { $0 }.forEach { pathComponents.remove(at: $0) }
        if pathComponents.last == .empty || pathComponents.last == .recursive { pathComponents.removeLast() }

        return pathComponents.joined(separator: .slash)
    }

    func deletingSuffixes() -> Path {
        let path = deletingSuffix(.allFiles).deletingSuffix(.slash)

        if path.hasSuffix(.anyCombination) && path.hasPrefix(.anyCombination) {
            return path.replacingOccurrences(of: .anyCombination, with: .empty)
        }

        return path
    }

    mutating func deleteSuffix(_ suffix: String) {
        self = deletingSuffix(suffix)
    }

    func deletingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }

        return substring(to: index(endIndex, offsetBy: -suffix.characters.count))
    }

    func hasDirectory(named name: String) -> Bool {
        return lowercased().range(of: name.lowercased()) != nil
    }

    func containsAnyDirectoryFrom(_ directories: [Path]) -> Bool {
        return directories.any(hasDirectory)
    }
}

func + <T>(lhs: [T], rhs: T) -> [T] {
    return lhs + [rhs]
}

extension Array where Element == Path {

    func any(_ predicate: (Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) { return true }
        }
        return false
    }

    func deletingSuffixes() -> [Path] {
        return map { $0.deletingSuffixes() }
    }
}
