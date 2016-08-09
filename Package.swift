//
//  Package.swift
//  whereami
//
//  Created by Victor Jalencas on 4/8/16.
//  Copyright © 2016 Hand Forged. All rights reserved.
//

import PackageDescription

let package = Package(
	name: "whereami",
	dependencies: [
		.Package(url: "https://github.com/jakeheis/SwiftCLI", majorVersion: 1, minor: 2)
	]
)
