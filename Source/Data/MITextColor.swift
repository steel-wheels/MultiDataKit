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

public enum MITextColor: Int
{
        case black      = 0x0
        case red        = 0x1
        case green      = 0x2
        case yellow     = 0x3
        case blue       = 0x4
        case magenta    = 0x5
        case cyan       = 0x6
        case white      = 0x7

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

        public static func decode(name nm: String) -> MITextColor? {
                let result: MITextColor?
                switch nm {
                case MITextColor.black.name:    result = .black
                case MITextColor.red.name:      result = .red
                case MITextColor.green.name:    result = .green
                case MITextColor.yellow.name:   result = .yellow
                case MITextColor.blue.name:     result = .blue
                case MITextColor.magenta.name:  result = .magenta
                case MITextColor.cyan.name:     result = .cyan
                case MITextColor.white.name:    result = .white
                default:                        result = nil
                }
                return result
        }
}
