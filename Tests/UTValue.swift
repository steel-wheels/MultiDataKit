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

public func testToString() -> Bool
{
        let val0 = MIValue(type: .int, value: .int(10))
        let val1 = MIValue(type: .int, value: .string("str"))
        let val2 = MIValue(type: .interface(nil, [
                "a": val0.type,
                "b": val1.type
        ]), value: .interface([
                "a": val0,
                "b": val1
        ]))
        print("testToString 1 -> " + val2.toString(withType: true))

        let val3 = MIValue(type: .array(val2.type), value: .array([
                val2, val2
        ]))
        print("testToString 2 -> " + val3.toString(withType: true))

        let text3 = MIJsonEncoder.encode(value: val3)
        print("testToString 3 -> " + text3.toString())

        let val4 = MIValue(type: .dictionary(val0.type), value: .dictionary([
                "c": val0,
                "d": val0
        ]))
        print("testToString 4 -> " + val4.toString(withType: false))

        return true
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

