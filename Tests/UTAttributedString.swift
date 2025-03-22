//
//  UTAttributedString.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2025/03/23.
//

import Foundation

private func divideString(string str: String) -> Int {
        let astr  = NSAttributedString(string: str)
        let lines = astr.divideByNewline()
        print("divideString: \(lines.count): \"\(str)\"")
        for line in lines {
                print(" -> \"" + line.string + "\"")
        }
        return lines.count
}

public func testAttributedString() -> Bool
{
        let res0 = divideString(string: "a\n") == 1
        let res1 = divideString(string: "") == 0
        let res2 = divideString(string: "\na\n\nb\nc") == 5
        return res0 && res1 && res2
}
