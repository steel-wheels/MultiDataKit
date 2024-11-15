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
                let res = val.toString(withType: false)
                NSLog("json file: \(res)")
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

        return res0 && res1
}
