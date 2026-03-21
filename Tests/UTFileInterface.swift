/*
 * @file UTFileInterface.swift
 * @description Unit test for MIFileInterface class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public func testFileInterface() -> Bool
{
        let fileif = MIFileInterface(input:  FileHandle.standardInput,
                                     output: FileHandle.standardOutput,
                                     error:  FileHandle.standardError)
        fileif.write(string: "INPUT\n")
        fileif.error(string: "ERROR\n")
        sleep(1)

        return true
}

