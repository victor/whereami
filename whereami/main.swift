//
//  main.swift
//  whereami
//
//  Created by Victor Jalencas on 02/09/14.
//  Copyright © 2014 Hand Forged. All rights reserved.
//

import Foundation


// main code

CLI.setup(name:"whereami", version:"1.0", description:"Get your location from the command line")
let whereamiCommand = WhereAmICommand()
let versionCommand = WAIVersionCommand()
CLI.registerCustomVersionCommand(versionCommand)
CLI.registerDefaultCommand(whereamiCommand)
let result = CLI.go()
if (result) {
    exit(0)
} else {
    exit(-1)
}
