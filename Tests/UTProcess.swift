/*
 * @file UTProcess.swift
 * @description Unit test for MIProcess class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public func testProcess() -> Bool
{
        let env     = MIEnvironment()
        let command = URL(fileURLWithPath: "/bin/ls")
        let args: Array<String> = [ "-l" ]

        let newproc = Process(environment: env)
        newproc.standardInput  = FileHandle.standardInput
        newproc.standardOutput = FileHandle.standardOutput
        newproc.standardError  = FileHandle.standardError
        newproc.executableURL  = command
        newproc.arguments = args

        NSLog("execute \(command)")
        var result = true
        do {
                try newproc.run()
                newproc.waitUntilExit()
        } catch {
                result = false
        }
        return result
}

