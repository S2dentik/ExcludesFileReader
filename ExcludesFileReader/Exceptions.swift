//
//  Exceptions.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

public enum CommandLineError: Error {
    case invalidOption(String)
    case abuseOfOptions(String)
    case invalidExclude(String)
    case invalidArguments(String)
    case excludesFileError(String)
    case cannotReadFromHelpFile
    case invalidInformationalOption(String)
}
