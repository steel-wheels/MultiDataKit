//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2024/10/20.
//

import Foundation

print("Hello, World!")

let result0 = testNumber()
let result1 = testValue()
let result2 = testToString()
let result3 = testValueConvert()
let result4 = testFileInterface()
let result5 = testJsonFile()
let result6 = testJsonEncode()
let result7 = testAttributedString()
let result8 = testEscapeSequence()

let summary = result0 && result1 && result2 && result3 && result4 && result5 && result6 && result7 && result8

if summary {
        print("SUMMARY: OK")
} else {
        print("SUMMARY: Error")
}

