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
let result3 = testJsonFile()
let result4 = testJsonEncode()
let result5 = testAttributedString()

let summary = result0 && result1 && result2 && result3 && result4 && result5

if summary {
        print("SUMMARY: OK")
} else {
        print("SUMMARY: Error")
}

