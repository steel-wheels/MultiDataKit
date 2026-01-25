//
//  UTEscapeSequemce.swift
//  UnitTest
//
//  Created by Tomoo Hamada on 2026/01/25.
//

import MultiDataKit
import Foundation

public func testEscapeSequence() -> Bool
{
        NSLog("test: escapce string")

        /*
         case moveCursorUp(Int)                          // (lines)
         case moveCursorDown(Int)                        // (lines)
         case moveCursorRight(Int)                       // (columns)
         case moveCursorLeft(Int)                        // (columns)
         case moveCursorToBeggingOfNextLine(Int)         // (lines)
         case moveCursorToBeggingOfPrevLine(Int)         // (lines)
         case moveCursorToColumn(Int)                    // (column)
         */

        let codes: Array<MIEscapeCode> = [
                .insertString("Hello"),
                .moveCursorToHome,
                .moveCursorTo(12, 34)
        ]
        var result = true
        for code in codes {
                if !testEscapeSequence(source: code) {
                        result = false
                }
        }
        return result
}

private func testEscapeSequence(source src: MIEscapeCode) -> Bool {
        let srcstr = src.description()
        NSLog("source: " + srcstr)

        let result: Bool
        switch MIEscapeCode.decode(string: src.encode()) {
        case .success(let codes):
                if codes.count == 1 {
                        let codestr = codes[0].description()
                        if srcstr == codestr {
                                result = true
                        } else {
                                NSLog("[Error] Unexpected decode result: \(codestr)")
                                result = false
                        }
                } else {
                        NSLog("[Error] Unexpected code num: \(codes.count )")
                        result = false
                }
        case .failure(let err):
                NSLog(MIError.errorToString(error: err))
                result = false
        }
        return result
}
