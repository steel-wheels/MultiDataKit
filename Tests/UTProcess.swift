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
        let fileif = MIFileInterface(input:  FileHandle.standardInput,
                                     output: FileHandle.standardOutput,
                                     error:  FileHandle.standardError)
        let env     = MIEnvironment()
        let command = URL(fileURLWithPath: "/bin/ls")
        let args: Array<String> = [ "-l" ]

        let newproc = Process(environment: env)
        newproc.fileInterface = fileif
        newproc.executableURL = command
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

