//
//  WAIVersionCommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  © 2014-2015 Hand Forged. All rights reserved.
//

import Foundation

class WAIVersionCommand : VersionCommand {

    override var commandShortcut: String?  {
        return "--version"
    }

    override func execute(arguments arguments: CommandArguments) throws  {
        print("whereami version \(CLI.appVersion)")
    }
}