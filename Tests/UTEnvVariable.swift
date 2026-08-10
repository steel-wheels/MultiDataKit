//
//  UTEnvVariable.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2026/04/05.
//

import MultiDataKit
import Foundation

public func testEnvVariable() -> Bool
{
        var result: Bool = true
        NSLog("test: environment variable")

        let envvar = MIEnvVariables(parent: nil)

        let path = URL(filePath: "/bin")
        envvar.set(urlValue: path, for: MIEnvVariables.pathVariable)

        if let lscmd = FileManager.default.searchExecutableFile(name: "ls", in: envvar) {
                NSLog("ls command: \(lscmd.path)")
        } else {
                NSLog("[Error] Failed to search ls command")
                result = false
        }

        return result
}

