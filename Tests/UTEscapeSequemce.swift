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
        let res0 = testCharacterArrtibute()
        let res1 = testColorCode()
        let res2 = testEscapeCode()
        return res0 && res1 && res2
}

private func testCharacterArrtibute() -> Bool
{
        NSLog("test: character attribute")

        let attrs: Array<MICharacterAttribute> = [
                .bold(true),
                .dim(false),
                .italic(true),
                .underline(false),
                .blink(true),
                .inverse(false),
                .hidden(true),
                .strikethrough(false)
        ]

        var result = true
        for attr in attrs {
                if !testEscapeSequence(attribute: attr) {
                        result = false
                }
         }
        return result
}

private func testEscapeSequence(attribute src: MICharacterAttribute) -> Bool {
        let srcstr = src.description()
        NSLog("source: " + srcstr)

        let result: Bool
        let encval = src.encode()
        if let dstattr = MICharacterAttribute.decode(code: encval) {
                let dststr = dstattr.description()
                if srcstr == dststr {
                        result = true
                } else {
                        NSLog("[Error] Unexpected decode result: \(dststr)")
                        result = false
                }
        } else {
                NSLog("destination; decode failed")
                result = false
        }
        return result
}

private func testColorCode() -> Bool
{
        NSLog("test: escapce color")

        let codes: Array<MIEscapeColorCode> = [
                .black(true),
                .red(false),
                .green(true),
                .yellow(false),
                .blue(true),
                .magenta(false),
                .cyan(true),
                .white(false),
                .defaultColor(true),
                .reset,
                .brightBlack(false),
                .brightRed(true),
                .brightGreen(false),
                .brightYellow(true),
                .brightBlue(false),
                .brightMagenta(true),
                .brightCyan(false),
                .brightWhite(true),
                .rgb256(false, 12),
                .rgbFull(true, 34, 45, 56)
        ]
        var result = true
        for code in codes {
                if !testColorCode(source: code) {
                        result = false
                }
        }
        return result
}

private func testColorCode(source src: MIEscapeColorCode) -> Bool
{
        let srcstr = src.description()
        NSLog("source: " + srcstr)

        let result: Bool
        let srccodes = src.encode()
        if let dst = MIEscapeColorCode.decode(codes: srccodes) {
                let dststr = dst.description()
                if srcstr == dststr {
                        result = true
                } else {
                        NSLog("[Error] Unexpected decode result: \(dststr)")
                        result = false
                }
        } else {
                NSLog("[Error] Failed to decode color")
                result = false
        }
        return result
}

private func testEscapeCode() -> Bool
{
        NSLog("test: escapce string")

        let codes: Array<MIEscapeCode> = [
                .insertString("Hello"),
                .moveCursorToHome,
                .moveCursorTo(12, 34),
                .moveCursorUp(56),
                .moveCursorDown(78),
                .moveCursorRight(89),
                .moveCursorLeft(90),
                .moveCursorToBeggingOfNextLine(1),
                .moveCursorToBeggingOfPrevLine(2),
                .moveCursorToColumn(3),
                .requestCursorPosition,
                .moveCursor1LineUp,
                .saveCursorPosition(4),
                .restoreCursorPosition(1),
                .eraceFromCursotUntilEndOfScreen,
                .eraceFromToBeginningOfScreen,
                .eraceEntireScreen,
                .eraceSavedLines,
                .eraceFromCusorToEndOfLine,
                .eraceStartOfLineToCursor,
                .eraceEntireLine //,
                //.setCharacterAttribute([.blink(true), .bold(false)]),
                //.resetAllCharacterAttributes
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
