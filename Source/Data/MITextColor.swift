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

        public static func decode(colorCodes codes: Array<Int>) -> MITextColor? {
                let result: MITextColor?
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
                        default:        result = nil
                        }
                default:
                        result = nil
                }
                return result
        }
}


