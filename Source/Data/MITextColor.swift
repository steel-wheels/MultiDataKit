/**
 * @file MITextColor.swift
 * @brief  Define MITextColor class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)
import Foundation

public enum MITextColor
{
        case black
        case red
        case green
        case yellow
        case blue
        case magenta
        case cyan
        case white

        public var name: String { get {
                let result: String
                switch self {
                case .black:            result = "black"
                case .red:              result = "red"
                case .green:            result = "green"
                case .yellow:           result = "yellow"
                case .blue:             result = "blue"
                case .magenta:          result = "magenta"
                case .cyan:             result = "cyan"
                case .white:            result = "white"
                }
                return result
        }}

        public func encode(isForeground fg: Bool) -> Array<Int> {
                let result: Array<Int>
                switch self {
                case .black:            result = [fg ? 30 : 40]
                case .red:              result = [fg ? 31 : 41]
                case .green:            result = [fg ? 32 : 42]
                case .yellow:           result = [fg ? 33 : 43]
                case .blue:             result = [fg ? 34 : 44]
                case .magenta:          result = [fg ? 35 : 45]
                case .cyan:             result = [fg ? 36 : 46]
                case .white:            result = [fg ? 37 : 47]
                }
                return result
        }

        public static func decode(colorCodes codes: Array<Int>) -> (Bool, MITextColor)? {
                var isfg:       Bool         = false
                var color:      MITextColor? = nil

                guard codes.count == 1 else {
                        return nil
                }
                switch codes[0] {
                case 30:        isfg = true  ; color = .black
                case 40:        isfg = false ; color = .black
                case 31:        isfg = true  ; color = .red
                case 41:        isfg = false ; color = .red
                case 32:        isfg = true  ; color = .green
                case 42:        isfg = false ; color = .green
                case 33:        isfg = true  ; color = .yellow
                case 43:        isfg = false ; color = .yellow
                case 34:        isfg = true  ; color = .blue
                case 44:        isfg = false ; color = .blue
                case 35:        isfg = true  ; color = .magenta
                case 45:        isfg = false ; color = .magenta
                case 36:        isfg = true  ; color = .cyan
                case 46:        isfg = true  ; color = .cyan
                case 37:        isfg = true  ; color = .white
                case 47:        isfg = false ; color = .white
                default:        isfg = false ; color = nil
                }
                if let c = color {
                        return (isfg, c)
                } else {
                        return nil
                }
        }
}

/*
public enum MITextColor
{
        case black(Bool)        // true: foreground, false: background
        case red(Bool)
        case green(Bool)
        case yellow(Bool)
        case blue(Bool)
        case magenta(Bool)
        case cyan(Bool)
        case white(Bool)

        public var name: String { get {
                let result: String
                switch self {
                case .black(let fg):    result = "black(\(fg))"
                case .red(let fg):      result = "red(\(fg))"
                case .green(let fg):    result = "green(\(fg))"
                case .yellow(let fg):   result = "yellow(\(fg))"
                case .blue(let fg):     result = "blue(\(fg))"
                case .magenta(let fg):  result = "magenta(\(fg))"
                case .cyan(let fg):     result = "cyan(\(fg))"
                case .white(let fg):    result = "white(\(fg))"
                }
                return result
        }}

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
                }
                return result
        }


}


*/

