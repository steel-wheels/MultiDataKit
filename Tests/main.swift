//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2024/10/20.
//

import Foundation

print("Hello, World!")

let result0 = testValue()
let result1 = testToString()
let result2 = testJsonFile()
let result3 = testJsonEncode()
let result4 = testAttributedString()

let summary = result0 && result1 && result2 && result3 && result4

if summary {
        print("SUMMARY: OK")
} else {
        print("SUMMARY: Error")
}

