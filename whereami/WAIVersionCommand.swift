//
//  WAIVersionCommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  Copyright (c) 2014 Hand Forged. All rights reserved.
//

import Foundation

class WAIVersionCommand : VersionCommand {

    override func commandName() -> String  {
        return "version"
    }

    override func commandShortcut() -> String?  {
        return "--version"
    }

    override func execute() -> ExecutionResult  {
        println("whereami version \(self.version)")
        return success()
    }
}