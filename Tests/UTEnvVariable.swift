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

        let NUMKEY = "NUMBER"
        envvar.set(number: NSNumber(value: 123), forKey: NUMKEY)
        if let num = envvar.number(forKey: NUMKEY) {
                if num.intValue != 123 {
                        NSLog("[Error] Unexpexted number: \(num.intValue)")
                        result = false
                }
        } else {
                NSLog("[Error] Failed to set number")
                result = false
        }

        let STRKEY = "STR"
        envvar.set(string: "Hello", forKey: STRKEY)
        if let str = envvar.string(forKey: STRKEY) {
                if str != "Hello" {
                        NSLog("[Error] Unexpexted string: \(str)")
                        result = false
                }
        } else {
                NSLog("[Error] Failed to set string")
                result = false
        }

        let paths: Array<String> = [
                "/bin", " /usr/bin"
        ]
        envvar.set(strings: paths, forKey: MIEnvVariables.paths)
        if let p = envvar.strings(forKey: MIEnvVariables.paths) {
                if p.count != 2 {
                        NSLog("[Error] Unexpexted array element num: \(p.count)")
                        result = false
                }
        } else {
                NSLog("[Error] Failed to set strings")
                result = false
        }


        return result
}

