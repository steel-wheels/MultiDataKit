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
        let fileif = MIFileInterface()
        fileif.setInputReader(readFunctionn: {
                (str: String) -> Void in
                NSLog("Input: \(str)")
        })
        fileif.setOutputReader(readFunctionn: {
                (str: String) -> Void in
                NSLog("Output: \(str)")
        })
        fileif.setErrorReader(readFunctionn: {
                (str: String) -> Void in
                NSLog("Error: \(str)")
        })
        fileif.write(input: "INPUT")
        fileif.write(output: "OUTPUT")
        fileif.write(error: "ERROR")

        sleep(1)

        return true
}

