/*
 * @file UTValue.swift
 * @description Unit test for MIValue class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public func printValue(name nm: String, value val: MIValue){
        print(nm + " : " + val.toString())
}

public func testToString() -> Bool
{
        let val0 = MIValue(signedIntValue: 10)
        let val1 = MIValue(stringValue: "str")
        let val2 = MIValue(arrayValue: [val1, val1])
        print("testToString 2 -> " + val2.toString())

        let text2 = MIJsonEncoder.encode(value: val2)
        print("testToString 3 -> " + text2.toString())

        let val3 = MIValue(dictionaryValue: [
                "a": val0, "b": val1
        ])
        print("testToString 4 -> " + val3.toString())

        return true
}

public func testValue() -> Bool
{
        var result = true

        var values0: Array<MIValue> = []
        let val0 = MIValue(booleanValue: true)          ; values0.append(val0)
        let val1 = MIValue(unsignedIntValue: 1234)      ; values0.append(val1)
        let val2 = MIValue(signedIntValue: -2345)       ; values0.append(val2)
        let val3 = MIValue(floatValue: -12.34)          ; values0.append(val3)
        printValue(name: "val0", value: val0)
        for i in  0..<values0.count {
                printValue(name: "val\(i)", value: values0[i])
        }

        if let cast0 = val3.cast(to: .signedIntType) {
                printValue(name: "cast0", value: cast0)
        } else {
                print("[Error] Vailed to cast")
                result = false
        }
        if let cast1 = val2.cast(to: .floatType) {
                printValue(name: "cast1", value: cast1)
        } else {
                print("[Error] Vailed to cast")
                result = false
        }

        print("adjust types")
        var values1: Array<MIValue> = []
        values1.append(MIValue(unsignedIntValue: 10))
        values1.append(MIValue(signedIntValue: -10))
        values1.append(MIValue(floatValue: 1.23))
        switch MIValue.adjustValueTypes(values: values1) {
        case .success(let (_, uvalues)):
                for i in  0..<uvalues.count {
                        printValue(name: "val\(i)", value: uvalues[i])
                }
        case .failure(let err):
                print("[Error] " + MIError.errorToString(error: err))
        }

        return result
}

