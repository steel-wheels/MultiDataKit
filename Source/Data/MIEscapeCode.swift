/*
 * @file MIEscapeCode.swift
 * @description Define MIEscapeCode
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import Foundation

public struct MIEscapeColor
{
        public var r : Int
        public var g : Int
        public var b : Int

        public init() {
                self.r = 0
                self.g = 0
                self.b = 0
        }

        public var rgbName: String { get {
                return "{\(self.r), \(self.g), \(self.b)}"
        }}

        public var foregroundColorCode: String { get {
                // ESC[38;2;R;G;Bm
                return "\(Character.ESC)[38;2;\(self.r);\(self.g);\(self.b)m"
        }}

        public var backgroundColorCode: String { get {
                // ESC[48;2;R;G;Bm
                return "\(Character.ESC)[48;2;\(self.r);\(self.g);\(self.b)m"
        }}
}

func == (left: MIEscapeColor, right: MIEscapeColor) -> Bool {
        return     left.r == right.r && left.g == right.g && left.b == right.b
}

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

public enum MIEscapeColorCode
{
        /* 8-16 colors */
        case black(Bool)
        case red(Bool)
        case green(Bool)
        case yellow(Bool)
        case blue(Bool)
        case magenta(Bool)
        case cyan(Bool)
        case white(Bool)
        case defaultColor(Bool)
        case reset

        case brightBlack(Bool)
        case brightRed(Bool)
        case brightGreen(Bool)
        case brightYellow(Bool)
        case brightBlue(Bool)
        case brightMagenta(Bool)
        case brightCyan(Bool)
        case brightWhite(Bool)

        case rgb256(Bool, Int)
        case rgbFull(Bool, Int, Int, Int)

        public func description() -> String {
                let result: String
                switch self {
                case .black(let fg):            result = "black(\(property(fg)))"
                case .red(let fg):              result = "red(\(property(fg)))"
                case .green(let fg):            result = "green(\(property(fg)))"
                case .yellow(let fg):           result = "yellow(\(property(fg)))"
                case .blue(let fg):             result = "blue(\(property(fg)))"
                case .magenta(let fg):          result = "magenta(\(property(fg)))"
                case .cyan(let fg):             result = "cyan(\(property(fg)))"
                case .white(let fg):            result = "white(\(property(fg)))"
                case .defaultColor(let fg):     result = "defaultColor(\(property(fg)))"
                case .reset:                    result = "reset"
                case .brightBlack(let fg):      result = "brightBlack(\(property(fg)))"
                case .brightRed(let fg):        result = "brightRed(\(property(fg)))"
                case .brightGreen(let fg):      result = "brightGreen(\(property(fg)))"
                case .brightYellow(let fg):     result = "brightYellow(\(property(fg)))"
                case .brightBlue(let fg):       result = "brightBlue(\(property(fg)))"
                case .brightMagenta(let fg):    result = "brightMagenta(\(property(fg)))"
                case .brightCyan(let fg):       result = "brightCyan(\(property(fg)))"
                case .brightWhite(let fg):      result = "brightWhite(\(property(fg)))"
                case .rgb256(let fg, let v):    result = "bgb256(\(property(fg)), \(v))"
                case .rgbFull(let fg, let r, let g, let b):
                                                result = "bgbFull(\(property(fg)), \(r), \(g), \(b))"
                }
                return result
        }

        public func encode() -> Array<Int> {
                let result: Array<Int>
                switch self {
                case .black(let fg):            result = [fg ? 30 : 40]
                case .red(let fg):              result = [fg ? 31 : 41]
                case .green(let fg):            result = [fg ? 32 : 42]
                case .yellow(let fg):           result = [fg ? 33 : 43]
                case .blue(let fg):             result = [fg ? 34 : 44]
                case .magenta(let fg):          result = [fg ? 35 : 45]
                case .cyan(let fg):             result = [fg ? 36 : 46]
                case .white(let fg):            result = [fg ? 37 : 47]
                case .defaultColor(let fg):     result = [fg ? 39 : 49]
                case .reset:                    result = [0           ]

                case .brightBlack(let fg):      result = [fg ? 90 : 100]
                case .brightRed(let fg):        result = [fg ? 91 : 101]
                case .brightGreen(let fg):      result = [fg ? 92 : 102]
                case .brightYellow(let fg):     result = [fg ? 93 : 103]
                case .brightBlue(let fg):       result = [fg ? 94 : 104]
                case .brightMagenta(let fg):    result = [fg ? 95 : 105]
                case .brightCyan(let fg):       result = [fg ? 96 : 106]
                case .brightWhite(let fg):      result = [fg ? 97 : 107]

                case .rgb256(let fg, let v):
                                                result = fg ? [38, 5, v] : [48, 5, v]
                case .rgbFull(let fg, let r, let g, let b):
                                                result = fg ? [38, 2, r, g, b] : [48, 2, r, g, b]
                }
                return result
        }

        public static func decode(codes: Array<Int>) -> MIEscapeColorCode? {
                let result: MIEscapeColorCode?
                switch codes.count {
                case 1:
                        switch codes[0] {
                        case 30:        result = .black(true)
                        case 40:        result = .black(false)
                        case 31:        result = .red(true)
                        case 41:        result = .red(false)
                        case 32:        result = .green(true)
                        case 42:        result = .green(false)
                        case 33:        result = .yellow(true)
                        case 43:        result = .yellow(false)
                        case 34:        result = .blue(true)
                        case 44:        result = .blue(false)
                        case 35:        result = .magenta(true)
                        case 45:        result = .magenta(false)
                        case 36:        result = .cyan(true)
                        case 46:        result = .cyan(false)
                        case 37:        result = .white(true)
                        case 47:        result = .white(false)
                        case 39:        result = .defaultColor(true)
                        case 49:        result = .defaultColor(false)

                        case  0:        result = .reset

                        case 90:        result = .brightBlack(true)
                        case 100:       result = .brightBlack(false)
                        case 91:        result = .brightRed(true)
                        case 101:       result = .brightRed(false)
                        case 92:        result = .brightGreen(true)
                        case 102:       result = .brightGreen(false)
                        case 93:        result = .brightYellow(true)
                        case 103:       result = .brightYellow(false)
                        case 94:        result = .brightBlue(true)
                        case 104:       result = .brightBlue(false)
                        case 95:        result = .brightMagenta(true)
                        case 105:       result = .brightMagenta(false)
                        case 96:        result = .brightCyan(true)
                        case 106:       result = .brightCyan(false)
                        case 97:        result = .brightWhite(true)
                        case 107:       result = .brightWhite(false)
                        default:        result = nil
                        }
                case 3:
                        if codes[0] == 38 && codes[1] == 5 {
                                result = .rgb256(true, codes[2])
                        } else if codes[0] == 48 && codes[1] == 5 {
                                result = .rgb256(false, codes[2])
                        } else {
                                result = nil
                        }
                case 5:
                        if codes[0] == 38 && codes[1] == 2 {
                                result = .rgbFull(true, codes[2], codes[3], codes[4])
                        } else if codes[0] == 48 && codes[1] == 2 {
                                result = .rgbFull(false, codes[2], codes[3], codes[4])
                        } else {
                                result = nil
                        }
                default:
                        result = nil
                }
                return result
        }

        private func property(_ fg: Bool) -> String {
                return fg ? "fg" : "bg"
        }
}

/* Reference:
 *  - https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
 */
public enum MIEscapeCode
{
        /* Text edit */
        case insertString(String)

        /* Cursor Controls */
        case moveCursorToHome
        case moveCursorTo(Int, Int)                     // (line, column)
        case moveCursorUp(Int)                          // (lines)
        case moveCursorDown(Int)                        // (lines)
        case moveCursorRight(Int)                       // (columns)
        case moveCursorLeft(Int)                        // (columns)
        case moveCursorToBeggingOfNextLine(Int)         // (lines)
        case moveCursorToBeggingOfPrevLine(Int)         // (lines)
        case moveCursorToColumn(Int)                    // (column)
        case requestCursorPosition
        case moveCursor1LineUp
        case saveCursorPosition(Int)                    // 0:DEC, 1:SCO
        case restoreCursorPosition(Int)                 // 0:DEC, 1:SCO

        /* Erace operation */
        case eraceFromCursotUntilEndOfScreen
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
        case setColor(MIEscapeColorCode)

        public func description() -> String {
                let result: String
                switch self {
                case .insertString(let str):                    result = "insertString(\(str))"
                case .moveCursorToHome:                         result = "moveCursorToHome"
                case .moveCursorTo(let l, let c):               result = "moveCursorTo(\(l), \(c))"
                case .moveCursorUp(let l):                      result = "moveCursorUp(\(l))"
                case .moveCursorDown(let l):                    result = "moveCursorDown(\(l))"
                case .moveCursorRight(let c):                   result = "moveCursorRight(\(c))"
                case .moveCursorLeft(let c):                    result = "moveCursorLeft(\(c))"
                case .moveCursorToBeggingOfNextLine(let l):     result = "moveCursorToBeggingOfNextLine(\(l))"
                case .moveCursorToBeggingOfPrevLine(let l):     result = "moveCursorToBeggingOfPrevLine(\(l))"
                case .moveCursorToColumn(let c):                result = "moveCursorToColumn(\(c))"
                case .requestCursorPosition:                    result = "requestCursorPosition"
                case .moveCursor1LineUp:                        result = "moveCursor1LineUp"
                case .saveCursorPosition(let k):                result = "saveCursorPosition(\(k==0 ? "DEC": "SCO"))"
                case .restoreCursorPosition(let k):             result = "restoreCursorPosition(\(k==0 ? "DEC": "SCO"))"

                case .eraceFromCursotUntilEndOfScreen:          result = "eraceFromCursotUntilEndOfScreen"
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
                case .setColor(let color):                      result = "setColor(\(color.description()))"
                }
                return result
        }

        public func encode() -> String {
                let ESC = Character.ESC
                let result: String
                switch self {
                case .insertString(let str):                    result = str
                case .moveCursorToHome:                         result = "\(ESC)[H"
                case .moveCursorTo(let l, let c):               result = "\(ESC)[\(l);\(c)H"
                case .moveCursorUp(let l):                      result = "\(ESC)[\(l)A"
                case .moveCursorDown(let l):                    result = "\(ESC)[\(l)B"
                case .moveCursorRight(let c):                   result = "\(ESC)[\(c)C"
                case .moveCursorLeft(let c):                    result = "\(ESC)[\(c)D"
                case .moveCursorToBeggingOfNextLine(let l):     result = "\(ESC)[\(l)E"
                case .moveCursorToBeggingOfPrevLine(let l):     result = "\(ESC)[\(l)F"
                case .moveCursorToColumn(let c):                result = "\(ESC)[\(c)G"
                case .requestCursorPosition:                    result = "\(ESC)[6n"
                case .moveCursor1LineUp:                        result = "\(ESC)M"
                case .saveCursorPosition(let k):                result = k == 0 ? "\(ESC)7" : "\(ESC)[s"
                case .restoreCursorPosition(let k):             result = k == 0 ? "\(ESC)8" : "\(ESC)[u"

                case .eraceFromCursotUntilEndOfScreen:          result = "\(ESC)[0J"
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
                        case Character.ESC:
                                flushBuffer()
                                idx = str.index(after: idx)
                                if let err = decodeESC(string: str, index: &idx) {
                                        return err
                                }
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
                        mResult.append(.insertString(mBuffer))
                        mBuffer = ""
                }
        }

        private func decodeESC(string str: String, index idx: inout String.Index) -> NSError? {
                guard idx < str.endIndex else {
                        return unexpectedEndOfString(code: "<ESC>")
                }
                switch str[idx] {
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
                case "H":
                        idx = str.index(after: idx)
                        mResult.append(.moveCursorToHome)
                case "J":
                        idx = str.index(after: idx)
                        mResult.append(.eraceFromCursotUntilEndOfScreen)
                case "K":
                        idx = str.index(after: idx)
                        mResult.append(.eraceFromCusorToEndOfLine)
                case "s":
                        idx = str.index(after: idx)
                        mResult.append(.saveCursorPosition(1))
                case "u":
                        idx = str.index(after: idx)
                        mResult.append(.restoreCursorPosition(1))
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
                                mResult.append(.moveCursorRight(val0))
                        case "D":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorLeft(val0))
                        case "E":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorToBeggingOfNextLine(val0))
                        case "F":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorToBeggingOfPrevLine(val0))
                        case "G":
                                idx = str.index(after: idx)
                                mResult.append(.moveCursorToColumn(val0))
                        case "J":
                                idx = str.index(after: idx)
                                switch val0 {
                                case 0: mResult.append(.eraceFromCursotUntilEndOfScreen)
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

        private func decodeColorAndAttribute(codes: Array<Int>) -> Result<MIEscapeCode, NSError> {
                if let color = MIEscapeColorCode.decode(codes: codes) {
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
}
