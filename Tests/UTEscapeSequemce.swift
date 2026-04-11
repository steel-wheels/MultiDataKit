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

        let codes: Array<MITextColor> = [
                .black(true),
                .red(false),
                .green(true),
                .yellow(false),
                .blue(true),
                .magenta(false),
                .cyan(true),
                .white(false),
        ]
        var result = true
        for code in codes {
                if !testColorCode(source: code) {
                        result = false
                }
        }
        return result
}

private func testColorCode(source src: MITextColor) -> Bool
{
        let srcstr = src.name
        NSLog("source: " + srcstr)

        let result: Bool
        let srccodes = src.encode()
        if let dst = MITextColor.decode(colorCodes: srccodes) {
                let dststr = dst.name
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
                .string("Hello"),
                .key(.backspace),
                .key(.carriageReturn),
                .key(.delete),
                .key(.arrow(.right)),
                .key(.function(1)),
                .key(.function(5)),
                .key(.function(12)),
                .key(.formFeed),
                .key(.help),
                .key(.home),
                .key(.insert),
                .key(.menu),
                .key(.newline),
                .key(.pageUp),
                .key(.pageDown),
                .key(.tab),
                .key(.command("C")),
                .moveCursorTo(12, 34),
                .moveCursorUp(56),
                .moveCursorDown(78),
                .moveCursorForward(89),
                .moveCursorBackward(90),
                .moveCursorToBeginingOfNextLine(1),
                .moveCursorToBeginingOfPrevLine(2),
                .moveCursorToColumn(3),
                .requestCursorPosition,
                .moveCursor1LineUp,
                .saveCursorPosition(4),
                .restoreCursorPosition(1),
                .makeCursorVisible(true),
                .makeCursorVisible(false),
                .blinkCursor(true),
                .blinkCursor(false),
                .saveScreen,
                .restoreScreen,
                .eraceFromCursorUntilEndOfScreen,
                .eraceFromToBeginningOfScreen,
                .eraceEntireScreen,
                .eraceSavedLines,
                .eraceFromCusorToEndOfLine,
                .eraceStartOfLineToCursor,
                .eraceEntireLine,
                .setCharacterAttribute([.blink(true), .bold(false)]),
                .resetAllCharacterAttributes,
                .setColor(.blue(false))
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
                        let codes = codes.map { $0.encode() }
                        NSLog("[Error] Unexpected code num: \(codes.count):\(codes)")
                        result = false
                }
        case .failure(let err):
                NSLog(MIError.errorToString(error: err))
                result = false
        }
        return result
}
