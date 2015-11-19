//
//  Exceptions.swift
//  ExcludesFileReader
//
//  Created by Simion Schiopu on 11/19/15.
//  Copyright © 2015 YOPESO. All rights reserved.
//

public enum CommandLineError: ErrorType {
    case InvalidOption(String)
    case AbuseOfOptions(String)
    case InvalidExclude(String)
    case InvalidArguments(String)
    case ExcludesFileError(String)
    case CannotReadFromHelpFile
    case InvalidInformationalOption(String)
}