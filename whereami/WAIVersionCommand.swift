//
//  WAIVersionCommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  Copyright (c) 2014 Hand Forged. All rights reserved.
//

import Foundation

class WAIVersionCommand : VersionCommand {
    
    override var commandShortcut: String? {
        return "--version"
    }
    
    override func execute(arguments: CommandArguments) throws {
        print("whereami version \(CLI.appVersion)")
    }
    
}