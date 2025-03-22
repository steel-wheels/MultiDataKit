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

private func expandString(string str: String, width wid: Int) -> Int {
        let astr  = NSAttributedString(string: str)
        let res   = astr.adjustLength(width: wid, attribute: [:])
        print("expandString: \(res.length) \"\(res.string)\"")
        return res.length
}

public func testAttributedString() -> Bool
{
        let res0 = divideString(string: "a\n") == 1
        let res1 = divideString(string: "") == 0
        let res2 = divideString(string: "\na\n\nb\nc") == 5

        let estr  = "0123456789"
        let res00 = expandString(string: estr, width: 5) == 5
        let res01 = expandString(string: estr, width: 20) == 20
        let res02 = expandString(string: estr, width: 2) == 2

        return res0 && res1 && res2
                && res00 && res01 && res02
}
