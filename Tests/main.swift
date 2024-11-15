//
//  main.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2024/10/20.
//

import Foundation

print("Hello, World!")

let result0 = testValue()
let result1 = testJsonFile()

let summary = result0 && result1

if summary {
        print("SUMMARY: OK")
} else {
        print("SUMMARY: Error")
}

