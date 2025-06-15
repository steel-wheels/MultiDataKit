/*
 * @file UTNumber.swift
 * @description Unit test for NSNumber
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public func testNumber() -> Bool
{
        var result = true

        print("Number test")
        let num0 = NSNumber(integerLiteral: 1)
        result = checkNumber(expectedType: .signedIntType, number: num0) && result

        let num1 = NSNumber(integerLiteral: -123)
        result = checkNumber(expectedType: .signedIntType, number: num1) && result

        let num2 = NSNumber(floatLiteral: 12.34)
        result = checkNumber(expectedType: .floatType, number: num2) && result

        return result
}

private func checkNumber(expectedType exptype: MIValueType, number num: NSNumber) -> Bool
{
        var result: Bool = true

        let type = num.valueType
        print("check " + num.description + "=> " + type.name)
        if type != exptype {
                print("[Error] Unmatch type: \(type.name) <-> \(exptype.name)")
                result = false
        }
        return result
}
