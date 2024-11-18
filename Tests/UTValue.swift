/*
 * @file UTValue.swift
 * @description Unit test for MIValue class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public func printValue(name nm: String, value val: MIValue){
        print(nm + " : " + val.toString(withType: true))
}

public func testValue() -> Bool
{
        var values0: Array<MIValue> = []
        let val0 = MIValue.booleanValue(true) ;
        let val1 = MIValue.uintValue(1234) ;    values0.append(val1)
        let val2 = MIValue.intValue(-2345) ;    values0.append(val2)
        let val3 = MIValue.floatValue(-12.34) ; values0.append(val3)

        printValue(name: "val0", value: val0)
        for i in  0..<values0.count {
                printValue(name: "val\(i)", value: values0[i])
        }

        printValue(name: "cast: double -> int    ", value: val3.cast(to: .int)   ?? .booleanValue(false))
        printValue(name: "cast: int    -> double ", value: val1.cast(to: .float) ?? .booleanValue(false))

        print("adjust types")
        switch MIValue.adjustValueTypes(values: values0) {
        case .success(let (_, uvalues)):
                for i in  0..<uvalues.count {
                        printValue(name: "val\(i)", value: uvalues[i])
                }
        case .failure(let err):
                print("[Error] " + MIError.errorToString(error: err))
        }

        return true
}

