/*
 * @file MIKeyCode.swift
 * @description Extend MIEscapeCode class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */


#if os(OSX)

import AppKit
import Foundation

public extension MIEscapeCode
{
        static func decode(event evt: NSEvent) -> Array<MIEscapeCode> {
                if let key = evt.specialKey {
                        if let ecode = decode(specialKey: key) {
                                return [ecode]
                        }
                }
                guard let str = evt.characters else {
                        NSLog("No valid key input at \(#file)")
                        return []
                }
                if evt.modifierFlags.contains([.command]) {
                        return [.commandKey(str[str.startIndex])]
                } else if let code = decodeAsciiCode(string: str) {
                        return [code]
                } else {
                        let len = str.lengthOfBytes(using: .utf8)
                        let result: Array<MIEscapeCode> = [
                                .insertString(str),
                                .moveCursorForward(len)
                        ]
                        return result
                }
        }

        private static func decode(specialKey key: NSEvent.SpecialKey) -> MIEscapeCode? {
                let result: MIEscapeCode?
                switch key {
                case .backspace:                result = .backspaceKey
                case .backTab:                  result = nil
                case .begin:                    result = nil
                case .break:                    result = nil
                case .carriageReturn:           result = .carriageReturnKey
                case .clearDisplay:             result = nil
                case .clearLine:                result = nil
                case .delete:                   result = .deleteKey
                case .deleteCharacter:          result = nil
                case .deleteForward:            result = nil
                case .deleteLine:               result = nil
                case .downArrow:                result = .arrowKey(.down)
                case .end:                      result = nil
                case .enter:                    result = .newlineKey    // enter == newline
                case .newline:                  result = .newlineKey
                case .execute:                  result = nil
                case .f1:                       result = .functionKey(1)
                case .f2:                       result = .functionKey(2)
                case .f3:                       result = .functionKey(3)
                case .f4:                       result = .functionKey(4)
                case .f5:                       result = .functionKey(5)
                case .f6:                       result = .functionKey(6)
                case .f7:                       result = .functionKey(7)
                case .f8:                       result = .functionKey(8)
                case .f9:                       result = .functionKey(9)
                case .f10:                      result = .functionKey(10)
                case .f11:                      result = .functionKey(11)
                case .f12:                      result = .functionKey(12)
                case .f13:                      result = nil
                case .f14:                      result = nil
                case .f15:                      result = nil
                case .f16:                      result = nil
                case .f17:                      result = nil
                case .f18:                      result = nil
                case .f19:                      result = nil
                case .f20:                      result = nil
                case .f21:                      result = nil
                case .f22:                      result = nil
                case .f23:                      result = nil
                case .f24:                      result = nil
                case .f25:                      result = nil
                case .f26:                      result = nil
                case .f27:                      result = nil
                case .f28:                      result = nil
                case .f29:                      result = nil
                case .f30:                      result = nil
                case .f31:                      result = nil
                case .f32:                      result = nil
                case .f33:                      result = nil
                case .f34:                      result = nil
                case .f35:                      result = nil
                case .find:                     result = nil
                case .formFeed:                 result = .formFeedKey
                case .help:                     result = .helpKey
                case .home:                     result = .homeKey
                case .insert:                   result = .insertKey
                case .insertCharacter:          result = nil
                case .insertLine:               result = nil
                case .leftArrow:                result = .arrowKey(.left)
                case .lineSeparator:            result = nil
                case .menu:                     result = .menuKey
                case .modeSwitch:               result = nil
                case .newline:                  result = .newlineKey
                case .next:                     result = nil
                case .pageDown:                 result = .pageDownKey
                case .pageUp:                   result = .pageUpKey
                case .paragraphSeparator:       result = nil
                case .pause:                    result = nil
                case .prev:                     result = nil
                case .print:                    result = nil
                case .printScreen:              result = nil
                case .redo:                     result = nil
                case .reset:                    result = nil
                case .rightArrow:               result = .arrowKey(.right)
                case .scrollLock:               result = nil
                case .select:                   result = nil
                case .stop:                     result = nil
                case .sysReq:                   result = nil
                case .system:                   result = nil
                case .tab:                      result = .tabKey
                case .undo:                     result = nil
                case .upArrow:                  result = .arrowKey(.up)
                case .user:                     result = nil
                default:                        result = nil
                }
                return result
        }

        private static func decodeAsciiCode(string str: String) -> MIEscapeCode? {
                var result: MIEscapeCode? = nil
                let endidx = str.endIndex
                let idx    = str.startIndex
                if idx < endidx {
                        if let aval = str[idx].asciiValue {
                                if 1 <= aval && aval <= 26 {
                                        let scalar = UnicodeScalar("a").value + UInt32(aval) - 1
                                        if let ucode = UnicodeScalar(scalar) {
                                                result = .controlKey(Character(ucode))
                                        }
                                }
                        }
                }
                return result
        }
}

#endif

