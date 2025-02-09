/*
 * @file UTStringStream.swift
 * @description Unit test for KSStringStream class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MultiDataKit
import Foundation

private func testJsonString(string str: String) -> Bool
{
        switch MIJsonFile.load(string: str) {
        case .success(let val):
                let res1 = val.toString(withType: false)
                NSLog("json file: \(res1)")
                let res2 = val.toString(withType: true)
                NSLog("typed file: \(res2)")
                return true
        case .failure(let err):
                NSLog(MIError.errorToString(error: err))
                return false
        }
}

public func testJsonFile() -> Bool
{
        let text0 = "{\n"
                  + "a  : -100.12,\n"
                  + "bc : \"hello\"\n"
                  + "t  : %{| text |%}\n"
                  + "}"
        let res0 = testJsonString(string: text0)

        let text1 = "{\n"
                  + "  a : [4, 1.2] \n"
                  + "}"
        let res1 = testJsonString(string: text1)

        let text2 = "[\n"
                  + "  {a : [4, 1.2], b: \"hello\"}, \n"
                  + "  {a : [4, 1.2], b: \"world\"} \n"
                  + "]"
        let res2 = testJsonString(string: text2)

        return res0 && res1 && res2
}

private func printText(label lab: String, value val: MIValue)
{
        let text = MIJsonEncoder.encode(value: val)
        print(lab + " -> " + text.toString())
}

public func testJsonEncode() -> Bool
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
        printText(label: "testJsonEncode 1", value: val2)

        let val3 = MIValue(type: .array(val2.type), value: .array([
                val2, val2
        ]))
        printText(label: "testJsonEncode 2", value: val3)

        let val4 = MIValue(type: .dictionary(val0.type), value: .dictionary([
                "c": val0,
                "d": val0
        ]))
        printText(label: "testJsonEncode 3", value: val4)

        let val5 = MIValue(type: .interface(nil, [
                "e": val3.type,
                "f": val4.type
        ]), value: .interface([
                "e": val3,
                "f": val4
        ]))
        printText(label: "testJsonEncode 4", value: val5)

        return true
}

