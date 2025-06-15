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
                let res1 = val.toString()
                NSLog("json file: \(res1)")
                let res2 = val.toString()
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
        let val0 = MIValue(signedIntValue: 10)
        let val1 = MIValue(stringValue: "str")
        let val2 = MIValue(arrayValue: [val0, val1])
        printText(label: "testJsonEncode 1", value: val2)

        let val4 = MIValue(dictionaryValue: [
                "a": val0, "b": val1
        ])
        printText(label: "testJsonEncode 3", value: val4)

        return true
}

