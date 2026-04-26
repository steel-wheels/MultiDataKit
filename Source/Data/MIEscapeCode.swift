/*
 * @file MIEscapeCode.swift
 * @description Define MIEscapeCode
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import Foundation

public enum MICharacterAttribute
{
        case bold(Bool)
        case dim(Bool)
        case italic(Bool)
        case underline(Bool)
        case blink(Bool)
        case inverse(Bool)
        case hidden(Bool)
        case strikethrough(Bool)

        public func description() -> String {
                let result: String
                switch self {
                case .bold(let f):              result = "bold(\(f))"
                case .dim(let f):               result = "dim(\(f))"
                case .italic(let f):            result = "italic(\(f))"
                case .underline(let f):         result = "underline(\(f))"
                case .blink(let f):             result = "blink(\(f))"
                case .inverse(let f):           result = "inverse(\(f))"
                case .hidden(let f):            result = "hidden(\(f))"
                case .strikethrough(let f):     result = "strikethrough(\(f))"
                }
                return result
        }

        public func encode() -> Int {
                let result: Int
                switch self {
                case .bold(let f):              result = f ? 0x1 : 0x21
                case .dim(let f):               result = f ? 0x2 : 0x22
                case .italic(let f):            result = f ? 0x3 : 0x23
                case .underline(let f):         result = f ? 0x4 : 0x24
                case .blink(let f):             result = f ? 0x5 : 0x25
                case .inverse(let f):           result = f ? 0x7 : 0x27
                case .hidden(let f):            result = f ? 0x8 : 0x28
                case .strikethrough(let f):     result = f ? 0x9 : 0x29
                }
                return result
        }

        public static func decode(code: Int) -> MICharacterAttribute? {
                guard 0x1 <= code && code <= 0x29 else {
                        return nil
                }
                let doset = (code & 0xf0) != 0x20
                let result: MICharacterAttribute?
                switch code & 0xf {
                case 1: result = .bold(doset)
                case 2: result = .dim(doset)
                case 3: result = .italic(doset)
                case 4: result = .underline(doset)
                case 5: result = .blink(doset)
                case 7: result = .inverse(doset)
                case 8: result = .hidden(doset)
                case 9: result = .strikethrough(doset)
                default: result = nil
                }
                return result
        }
}

public enum MIArrowKeyType {
        case up
        case down
        case right
        case left

        public var code: Character { get {
                let result: Character
                switch self {
                case .up:       result = "A"
                case .down:     result = "B"
                case .right:    result = "C"
                case .left:     result = "D"
                }
                return result
        }}

        public var description: String { get {
                let result: String
                switch self {
                case .left:     result = "left"
                case .right:    result = "right"
                case .up:       result = "up"
                case .down:     result = "down"
                }
                return result
        }}
}

public enum MIEscapeKeyCode
{
        case    backspace
        case    carriageReturn
        case    lineFeed
        case    enter
        case    delete
        case    arrow(MIArrowKeyType)
        case    function(Int)
        case    formFeed
        case    help
        case    home
        case    insert
        case    menu
        case    pageUp
        case    pageDown
        case    tab
        case    command(Character)
        case    control(Character)

        public func encode() -> String {
                let ESC = String(Character.ESC)
                let result: String
                switch self {
                case .backspace:        result = String(Character.BS)
                case .carriageReturn:   result = String(Character.CR)
                case .lineFeed:         result = String(Character.LF)
                case .enter:            result = String(Character.LF)
                case .delete:           result = String(Character.DEL)
                case .arrow(let atype):
                        switch atype {
                        case .up:       result = ESC + "[A"
                        case .down:     result = ESC + "[B"
                        case .right:    result = ESC + "[C"
                        case .left:     result = ESC + "[D"
                        }
                case .function(let fid):
                        switch fid {
                        case 1:         result = ESC + "0P"
                        case 2:         result = ESC + "0Q"
                        case 3:         result = ESC + "0R"
                        case 4:         result = ESC + "0S"
                        case 5:         result = ESC + "[15~"
                        case 6:         result = ESC + "[17~"
                        case 7:         result = ESC + "[18~"
                        case 8:         result = ESC + "[19~"
                        case 9:         result = ESC + "[20~"
                        case 10:        result = ESC + "[21~"
                        case 11:        result = ESC + "[23~"
                        case 12:        result = ESC + "[24~"
                        default:
                                NSLog("[Error] Unknown function key number at \(#file)")
                                result = ESC + "0P" // = F1
                        }
                case .formFeed:         result = String(Character.FF)
                case .help:             result = ESC + "[28~"
                case .home:             result = ESC + "[H"
                case .insert:           result = ESC + "[2~"
                case .menu:             result = ESC + "[29~"
                case .pageUp:           result = ESC + "[5~"
                case .pageDown:         result = ESC + "[6~"
                case .tab:              result = String(Character.TAB)
                case .command(let c):   result = ESC + "^0\(c)"
                case .control(let c):   result = ESC + "^1\(c)"
                }
                return result
        }

        public var description: String { get {
                let result: String
                switch self {
                case .backspace:        result = "BS"
                case .carriageReturn:   result = "CR"
                case .lineFeed:         result = "LF"
                case .enter:            result = "ENT"
                case .delete:           result = "DEL"
                case .arrow(let type):  result = "arrow(\(type.description))"
                case .function(let f):  result = "func(\(f))"
                case .formFeed:         result = "FF"
                case .help:             result = "HELP"
                case .home:             result = "HOME"
                case .insert:           result = "INS"
                case .menu:             result = "MENU"
                case .pageUp:           result = "PUP"
                case .pageDown:         result = "PDN"
                case .tab:              result = "TAB"
                case .command(let c):   result = "cmd(\(c))"
                case .control(let c):   result = "ctrl(\(c)"
                }
                return result
        }}
}

/* Reference:
 *  - https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
 */
public enum MIEscapeCode
{
        /* Text edit */
        case string(String)                             // insert string and move cursor forward

        /* Key */
        case key(MIEscapeKeyCode)

        /* Cursor Controls */
        case moveCursorTo(Int, Int)                     // (line, column)
        case moveCursorUp(Int)                          // (lines)
        case moveCursorDown(Int)                        // (lines)
        case moveCursorForward(Int)                     // (columns)
        case moveCursorBackward(Int)                    // (columns)
        case moveCursorToBeginingOfNextLine(Int)         // (lines)
        case moveCursorToBeginingOfPrevLine(Int)         // (lines)
        case moveCursorToColumn(Int)                    // (column)
        case requestCursorPosition
        case moveCursor1LineUp
        case saveCursorPosition(Int)                    // 0:DEC, 1:SCO
        case restoreCursorPosition(Int)                 // 0:DEC, 1:SCO
        case makeCursorVisible(Bool)
        case blinkCursor(Bool)                          // Custom defined

        /* screen */
        case restoreScreen
        case saveScreen
        case enableAlternativeBuffer(Bool)

        /* Erace operation */
        case eraceFromCursorWithLength(Int)             // (length)
        case eraceFromCursorUntilEndOfScreen
        case eraceFromToBeginningOfScreen
        case eraceEntireScreen
        case eraceSavedLines
        case eraceFromCusorToEndOfLine
        case eraceStartOfLineToCursor
        case eraceEntireLine

        /*  Charactet Attribute */
        case setCharacterAttribute(Array<MICharacterAttribute>)
        case resetAllCharacterAttributes

        /* Character Color */
        case setColor(MITextColor)

        public func description() -> String {
                let result: String
                switch self {
                case .string(let str):                          result = "string(\(str))"
                case .key(let key):                             result = "key(\(key.description))"
                case .moveCursorTo(let l, let c):               result = "moveCursorTo(\(l), \(c))"
                case .moveCursorUp(let l):                      result = "moveCursorUp(\(l))"
                case .moveCursorDown(let l):                    result = "moveCursorDown(\(l))"
                case .moveCursorForward(let c):                 result = "moveCursorForward(\(c))"
                case .moveCursorBackward(let c):                result = "moveCursorBackward(\(c))"
                case .moveCursorToBeginingOfNextLine(let l):    result = "moveCursorToBegningOfNextLine(\(l))"
                case .moveCursorToBeginingOfPrevLine(let l):    result = "moveCursorToBegningOfPrevLine(\(l))"
                case .moveCursorToColumn(let c):                result = "moveCursorToColumn(\(c))"
                case .requestCursorPosition:                    result = "requestCursorPosition"
                case .moveCursor1LineUp:                        result = "moveCursor1LineUp"
                case .saveCursorPosition(let k):                result = "saveCursorPosition(\(k==0 ? "DEC": "SCO"))"
                case .restoreCursorPosition(let k):             result = "restoreCursorPosition(\(k==0 ? "DEC": "SCO"))"
                case .makeCursorVisible(let f):                 result = "makeCursorVisible(\(f))"
                case .blinkCursor(let f):                       result = "blinkCursor(\(f))"
                case .restoreScreen:                            result = "restoreScreen"
                case .saveScreen:                               result = "saveScreen"
                case .enableAlternativeBuffer(let f):           result = "enableAlternativeBuffer(\(f))"

                case .eraceFromCursorWithLength(let l):         result = "eraceFromCorsorWithLength(\(l))"
                case .eraceFromCursorUntilEndOfScreen:          result = "eraceFromCursotUntilEndOfScreen"
                case .eraceFromToBeginningOfScreen:             result = "eraceFromToBeginningOfScreen"
                case .eraceEntireScreen:                        result = "eraceEntireScreen"
                case .eraceSavedLines:                          result = "eraceSavedLines"
                case .eraceFromCusorToEndOfLine:                result = "eraceFromCusorToEndOfLine"
                case .eraceStartOfLineToCursor:                 result = "eraceStartOfLineToCursor"
                case .eraceEntireLine:                          result = "eraceEntireLine"
                case .setCharacterAttribute(let attrs):
                        let astr = attrs.map { $0.description() }
                        let desc = astr.joined(separator: ",")
                        result = "setCharacterAttribute(\(desc))"
                case .resetAllCharacterAttributes:              result = "resetAllCharacterAttributes"
                case .setColor(let color):                      result = "setColor(\(color.name)"
                }
                return result
        }

        public func encode() -> String {
                let ESC = Character.ESC

                let result: String
                switch self {
                case .string(let str):                          result = str
                case .key(let key):                             result = key.encode()
                case .moveCursorTo(let l, let c):               result = "\(ESC)[\(l);\(c)H"
                case .moveCursorUp(let l):                      result = "\(ESC)[\(l)A"
                case .moveCursorDown(let l):                    result = "\(ESC)[\(l)B"
                case .moveCursorForward(let c):                 result = "\(ESC)[\(c)C"
                case .moveCursorBackward(let c):                result = "\(ESC)[\(c)D"
                case .moveCursorToBeginingOfNextLine(let l):    result = "\(ESC)[\(l)E"
                case .moveCursorToBeginingOfPrevLine(let l):    result = "\(ESC)[\(l)F"
                case .moveCursorToColumn(let c):                result = "\(ESC)[\(c)G"
                case .requestCursorPosition:                    result = "\(ESC)[6n"
                case .moveCursor1LineUp:                        result = "\(ESC)M"
                case .saveCursorPosition(let k):                result = k == 0 ? "\(ESC)7" : "\(ESC)[s"
                case .restoreCursorPosition(let k):             result = k == 0 ? "\(ESC)8" : "\(ESC)[u"
                case .makeCursorVisible(let f):                 result = f ? "\(ESC)[?25h" : "\(ESC)[?25l"
                case .blinkCursor(let f):                       result = f ? "\(ESC)[?25t" : "\(ESC)[?25f"
                case .restoreScreen:                            result = "\(ESC)[?47l"
                case .saveScreen:                               result = "\(ESC)[?47h"
                case .enableAlternativeBuffer(let f):           result = "\(ESC)[?1049\(f ? "h":"l")"
                case .eraceFromCursorWithLength(let l):         result = "\(ESC)[\(l)P"
                case .eraceFromCursorUntilEndOfScreen:          result = "\(ESC)[0J"
                case .eraceFromToBeginningOfScreen:             result = "\(ESC)[1J"
                case .eraceEntireScreen:                        result = "\(ESC)[2J"
                case .eraceSavedLines:                          result = "\(ESC)[3J"
                case .eraceFromCusorToEndOfLine:                result = "\(ESC)[0K"
                case .eraceStartOfLineToCursor:                 result = "\(ESC)[1K"
                case .eraceEntireLine:                          result = "\(ESC)[2K"

                case .setCharacterAttribute(let attrs):
                        let params = attrs.map{ "\($0.encode())" }
                        result = "\(ESC)[" + params.joined(separator: ";") + "m"
                case .resetAllCharacterAttributes:              result = "\(ESC)[0m"
                case .setColor(let color):
                        let params = color.encode().map{ "\($0)" }
                        result = "\(ESC)[" + params.joined(separator: ";") + "m"
                }
                return result
        }

        public static func decode(string str: String) -> Result<Array<MIEscapeCode>, NSError> {
                let decoder = MIEscapeCodeDecoder()
                return decoder.decode(string: str)
        }
}

private class MIEscapeCodeDecoder
{
        private var mResult:    Array<MIEscapeCode>
        private var mBuffer:    String

        public init() {
                mResult = []
                mBuffer = ""
        }

        public func decode(string str: String) -> Result<Array<MIEscapeCode>, NSError> {
                mResult = []
                var idx = str.startIndex
                if let err = decode(string: str, index: &idx) {
                        return .failure(err)
                } else {
                        return .success(mResult)
                }
        }

        private func decode(string str: String, index idx: inout String.Index) -> NSError? {
                let endidx = str.endIndex
                while idx < endidx {
                        switch str[idx] {
                        case Character.LF:
                                mResult.append(.key(.lineFeed))
                                idx = str.index(after: idx)
                        case Character.CR:
                                mResult.append(.key(.carriageReturn))
                                idx = str.index(after: idx)
                        case Character.ESC:
                                flushBuffer()
                                idx = str.index(after: idx)
                                if let err = decodeESC(string: str, index: &idx) {
                                        return err
                                }
                        case Character.DEL:
                                mResult.append(.key(.delete))
                                idx = str.index(after: idx)
                        case Character.BS:
                                mResult.append(.key(.backspace))
                                idx = str.index(after: idx)
                        case Character.FF:
                                mResult.append(.key(.formFeed))
                                idx = str.index(after: idx)
                        case Character.TAB:
                                mResult.append(.key(.tab))
                                idx = str.index(after: idx)
                        default:
                                mBuffer.append(str[idx])
                                idx = str.index(after: idx)
                        }
                }
                flushBuffer()
                return nil
        }

        private func flushBuffer() {
                if mBuffer.lengthOfBytes(using: .utf8) > 0 {
                        mResult.append(.string(mBuffer))
                        mBuffer = ""
                }
        }

        private func decodeESC(string str: String, index idx: inout String.Index) -> NSError? {
                guard idx < str.endIndex else {
                        return unexpectedEndOfString(code: "<ESC>")
                }
                switch str[idx] {
                case "0":
                        idx = str.index(after: idx)
                        if idx < str.endIndex {
                                switch str[idx] {
                                case "P": mResult.append(.key(.function(1)))
                                case "Q": mResult.append(.key(.function(2)))
                                case "R": mResult.append(.key(.function(3)))
                                case "S": mResult.append(.key(.function(4)))
                                default:
                                        return unknownSequenceError(code: "<ESC>0", value: String(str[idx]))
                                }
                                idx = str.index(after: idx)
                        } else {
                                return unexpectedEndOfString(code: "<ESC>0")
                        }
                case "7":
                        idx = str.index(after: idx)
                        mResult.append(.saveCursorPosition(0))
                case "8":
                        idx = str.index(after: idx)
                        mResult.append(.restoreCursorPosition(0))
                case "M":
                        idx = str.index(after: idx)
                        mResult.append(.moveCursor1LineUp)
                case "[":
                        idx = str.index(after: idx)
                        if let err = decodeESCBracket(string: str, index: &idx) {
                                return err
                        }
                case "^":
                        idx = str.index(after: idx)
                        if idx < str.endIndex {
                                let kind = str[idx]
                                idx = str.index(after: idx)
                                if idx < str.endIndex {
                                        let val = str[idx]
                                        idx = str.index(after: idx)
                                        switch kind {
                                        case "0": mResult.append(.key(.command(val)))
                                        case "1": mResult.append(.key(.control(val)))
                                        default:  return unexpectedEndOfString(code: "<ESC>^\(kind)\(val)")
                                        }
                                } else {
                                        return unexpectedEndOfString(code: "<ESC>^\(kind)")
                                }
                        } else {
                                return unexpectedEndOfString(code: "<ESC>^")
                        }
                default:
                        return unknownSequenceError(code: "<ESC>[", value: String(str[idx]))
                }
                return nil
        }

        private func decodeESCBracket(string str: String, index idx: inout String.Index) -> NSError? {
                guard idx < str.endIndex else {
                        return unexpectedEndOfString(code: "<ESC>[")
                }
                switch str[idx] {
                case MIArrowKeyType.left.code:
                        idx = str.index(after: idx)
                        mResult.append(.key(.arrow(.left)))
                case MIArrowKeyType.right.code:
                        idx = str.index(after: idx)
                        mResult.append(.key(.arrow(.right)))
                case MIArrowKeyType.up.code:
                        idx = str.index(after: idx)
                        mResult.append(.key(.arrow(.up)))
                case MIArrowKeyType.down.code:
                        idx = str.index(after: idx)
                        mResult.append(.key(.arrow(.down)))
                case "H":
                        idx = str.index(after: idx)
                        mResult.append(.key(.home))
                case "J":
                        idx = str.index(after: idx)
                        mResult.append(.eraceFromCursorUntilEndOfScreen)
                case "K":
                        idx = str.index(after: idx)
                        mResult.append(.eraceFromCusorToEndOfLine)
                case "s":
                        idx = str.index(after: idx)
                        mResult.append(.saveCursorPosition(1))
                case "u":
                        idx = str.index(after: idx)
                        mResult.append(.restoreCursorPosition(1))
                case "?":
                        idx = str.index(after: idx)
                        if let ivals = decodeInts(string: str, index: &idx) {
                                if let err = decodeESCBracketQuestionInt(string: str, index: &idx, intValues: ivals) {
                                        return err
                                }
                        } else {
                                return unexpectedEndOfString(code: "<ESC>[?")
                        }
                default:
                        if let ivals = decodeInts(string: str, index: &idx) {
                                if let err = decodeESCBracketInt(string: str, index: &idx, intValues: ivals) {
                                        return err
                                }
                        } else {
                                return unexpectedEndOfString(code: "<ESC>[")
                        }
                }
                return nil
        }

        private func decodeESCBracketInt(string str: String, index idx: inout String.Index, intValues ivals: Array<Int>) -> NSError? {
                guard idx < str.endIndex else {
                        let code = "<ESC>[" + ivals.map { "\($0)" }.joined(separator: ";")
                        return unexpectedEndOfString(code: code)
                }
                if ivals.count == 1 {
                        var docont = false
                        let val0 = ivals[0]
                        switch str[idx] {
                        case "A":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorUp(val0))
                        case "B":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorDown(val0))
                        case "C":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorForward(val0))
                        case "D":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorBackward(val0))
                        case "E":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorToBeginingOfNextLine(val0))
                        case "F":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorToBeginingOfPrevLine(val0))
                        case "G":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorToColumn(val0))
                        case "J":
                                idx = str.index(after: idx)
                                switch val0 {
                                case 0: mResult.append(.eraceFromCursorUntilEndOfScreen)
                                case 1: mResult.append(.eraceFromToBeginningOfScreen)
                                case 2: mResult.append(.eraceEntireScreen)
                                case 3: mResult.append(.eraceSavedLines)
                                default:
                                        return unknownSequenceError(code: "<ESC>[J", value: String(str[idx]))
                                }
                        case "K":
                                idx = str.index(after: idx)
                                switch(val0){
                                case 0: mResult.append(.eraceFromCusorToEndOfLine)
                                case 1: mResult.append(.eraceStartOfLineToCursor)
                                case 2: mResult.append(.eraceEntireLine)
                                default:
                                        return unknownSequenceError(code: "<ESC>[K", value: String(str[idx]))
                                }
                        case "P":
                                idx = str.index(after: idx)
                                mResult.append(.eraceFromCursorWithLength(val0))
                        case "m":
                                idx = str.index(after: idx)
                                if val0 == 0 {
                                        mResult.append(.resetAllCharacterAttributes)
                                } else {
                                        switch decodeColorAndAttribute(codes: ivals) {
                                        case .success(let code):
                                                mResult.append(code)
                                        case .failure(let err):
                                                return err
                                        }
                                }
                        case "n":
                                if val0 != 6 {
                                        NSLog("[Error] 6 is requires for request at \(#file)")
                                }
                                idx = str.index(after: idx)
                                mResult.append(.requestCursorPosition)
                        case "~":
                                idx = str.index(after: idx)
                                switch val0 {
                                case  2: mResult.append(.key(.insert))
                                case  5: mResult.append(.key(.pageUp))
                                case  6: mResult.append(.key(.pageDown))
                                case 15: mResult.append(.key(.function( 5)))
                                case 17: mResult.append(.key(.function( 6)))
                                case 18: mResult.append(.key(.function( 7)))
                                case 19: mResult.append(.key(.function( 8)))
                                case 20: mResult.append(.key(.function( 9)))
                                case 21: mResult.append(.key(.function(10)))
                                case 23: mResult.append(.key(.function(11)))
                                case 24: mResult.append(.key(.function(12)))
                                case 28: mResult.append(.key(.help))
                                case 29: mResult.append(.key(.menu))
                                default:
                                        return unknownSequenceError(code: "<ESC>[~", value: String(str[idx]))
                                }
                        default:
                                docont = true
                        }
                        if !docont {
                                return nil
                        }
                }
                if ivals.count == 2 {
                        var docont = false
                        let val0 = ivals[0]
                        let val1 = ivals[1]
                        switch str[idx] {
                        case "H", "f":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorTo(val0, val1))
                        default:
                                docont = true
                        }
                        if !docont {
                                return nil
                        }
                }
                switch str[idx] {
                case "m":
                        idx = str.index(after: idx)
                        switch decodeColorAndAttribute(codes: ivals) {
                        case .success(let code):
                                mResult.append(code)
                        case .failure(let err):
                                return err
                        }
                default:
                        return unknownSequenceError(code: "<ESC>[", value: String(str[idx]))
                }
                return nil
        }

        private func decodeESCBracketQuestionInt(string str: String, index idx: inout String.Index, intValues ivals: Array<Int>) -> NSError? {
                guard idx < str.endIndex else {
                        let code = "<ESC>[?" + ivals.map { "\($0)" }.joined(separator: ";")
                        return unexpectedEndOfString(code: code)
                }
                guard ivals.count == 1 else {
                        return tooManyIntParameters(code: "<ESC>[?")
                }
                var result: NSError? = nil
                switch ivals[0] {
                case 25:
                        switch str[idx] {
                        case "h":       mResult.append(.makeCursorVisible(true))
                        case "l":       mResult.append(.makeCursorVisible(false))
                        case "f":       mResult.append(.blinkCursor(false))
                        case "t":       mResult.append(.blinkCursor(true))
                        default:        result = unknownSequenceError(code: "<ESC>[?25", value: String(str[idx]))
                        }
                        idx = str.index(after: idx)
                case 47:
                        switch str[idx] {
                        case "h":       mResult.append(.saveScreen)
                        case "l":       mResult.append(.restoreScreen)
                        default:        result = unknownSequenceError(code: "<ESC>[?47", value: String(str[idx]))
                        }
                        idx = str.index(after: idx)
                case 1049:
                        switch str[idx] {
                        case "h":       mResult.append(.enableAlternativeBuffer(true))
                        case "l":       mResult.append(.enableAlternativeBuffer(false))
                        default:        result = unknownSequenceError(code: "<ESC>[?1049", value: String(str[idx]))
                        }
                        idx = str.index(after: idx)
                default:
                        result = unknownSequenceError(code: "<ESC>[?", value: String(ivals[0]))
                }
                return result
        }

        private func decodeColorAndAttribute(codes: Array<Int>) -> Result<MIEscapeCode, NSError> {
                if let color = MITextColor.decode(colorCodes: codes) {
                        return .success(.setColor(color))
                }
                var attrs: Array<MICharacterAttribute> = []
                for code in codes {
                        if let attr = MICharacterAttribute.decode(code: code) {
                                attrs.append(attr)
                        } else {
                                let err = unknownColorCode(code: "<ESC>[m", value: code)
                                return .failure(err)
                        }
                }
                return .success(.setCharacterAttribute(attrs))
        }

        private func decodeInts(string str: String, index idx: inout String.Index) -> Array<Int>? {
                var result: Array<Int>  = []
                var docont = true
                let endidx = str.endIndex
                while docont {
                        docont = false
                        if let ival = decodeInt(string: str, index: &idx) {
                                result.append(ival)
                                if idx < endidx {
                                        if str[idx] == ";" {
                                                idx = str.index(after: idx)
                                                docont = true
                                        } else {
                                                break
                                        }
                                } else {
                                        break
                                }
                        }
                }
                return result.count > 0 ? result : nil
        }

        private func decodeInt(string str: String, index idx: inout String.Index) -> Int? {
                var hasvalue    = false
                var result: Int = 0
                let endidx = str.endIndex
                while idx < endidx {
                        if let ival = Int("\(str[idx])") {
                                result   = result * 10 + ival
                                idx      = str.index(after: idx)
                                hasvalue = true
                        } else {
                                break
                        }
                }
                return hasvalue ? result : nil
        }

        private func unknownSequenceError(code: String, value: String) -> NSError {
                let msg = "Unknown escape sequence \"\(value)\" after \(code)"
                return MIError.parseError(message: msg, line: 0)
        }

        private func unknownColorCode(code: String, value: Int) -> NSError {
                let msg = "Unknown color code \"\(value)\" after \(code)"
                return MIError.parseError(message: msg, line: 0)
        }

        private func unexpectedEndOfString(code: String) -> NSError {
                let msg = "Unexpected end of string after \"\(code)\""
                return MIError.parseError(message: msg, line: 0)
        }

        private func tooManyIntParameters(code: String) -> NSError {
                let msg = "Too mamy parameters after \"\(code)\""
                return MIError.parseError(message: msg, line: 0)
        }
}
