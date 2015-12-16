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

CLI.defaultCommand = WhereAmICommand()
CLI.versionComand = WAIVersionCommand()

exit(CLI.go())
