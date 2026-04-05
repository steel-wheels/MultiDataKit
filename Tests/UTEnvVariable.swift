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
        NSLog("test: environment variable")

        let envvar = MIEnvVariables(parent: nil)

        var result: Bool = true

        let srccol: MITextColor = .blue(true)
        envvar.set(color: srccol, forKey: .terminalForeground)
        if let dstcol = envvar.color(forKey: .terminalForeground) {
                if srccol.name == dstcol.name {
                        NSLog("Expected col: \(srccol.name) == \(dstcol.name)")
                } else {
                        NSLog("[Error] Unexpected col: \(srccol.name) != \(dstcol.name)")
                        result = false
                }
        } else {
                NSLog("[Error] Failed to get color")
                result = false
        }
        return result
}

