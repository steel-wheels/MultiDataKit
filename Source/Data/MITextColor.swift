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

        public static func decode(escapeCodes codes: Array<Int>) -> MITextColor? {
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

        /*
        public var value: MIColor { get {
                let result: MIColor
                switch self {
                case .black:    result = MIColor.black
                case .red:      result = MIColor.red
                case .green:    result = MIColor.green
                case .yellow:   result = MIColor.yellow
                case .blue:     result = MIColor.blue
                case .magenta:  result = MIColor.magenta
                case .cyan:     result = MIColor.cyan
                case .white:    result = MIColor.white
                }
                return result
        }}

        public static func decode(color col: MIColor) -> MITextColor {
                #if os(OSX)
                guard let rgb = col.usingColorSpace(.sRGB) else {
                        NSLog("[Error] Failed to makge RGB info at \(#file)")
                        return .black
                }
                let r = rgb.redComponent
                let g = rgb.greenComponent
                let b = rgb.blueComponent
                #else
                guard let comps = col.cgColor.components else {
                        NSLog("[Error] Failed to makge RGB info at \(#file)")
                        return .black
                }
                let r = comps[0]
                let g = comps[1]
                let b = comps[2]
                #endif
                let result: MITextColor
                if r > 0.5 {
                        if g > 0.5 {
                                if b > 0.5 {
                                        /* R:YES, G:YES, B:YES */
                                        result = .white
                                } else {
                                        /* R:YES, G:YES, B:NO */
                                        result = .yellow
                                }
                        } else {
                                if b > 0.5 {
                                        /* R:YES, G:NO, B:YES */
                                        result = .magenta
                                } else {
                                        /* R:YES, G:NO, B:NO */
                                        result = .red
                                }
                        }
                } else {
                        if g > 0.5 {
                                if b > 0.5 {
                                        /* R:NO, G:YES, B:YES */
                                        result = .cyan
                                } else {
                                        /* R:NO, G:YES, B:NO */
                                        result = .green
                                }
                        } else {
                                if b > 0.5 {
                                        /* R:NO, G:NO, B:YES */
                                        result = .blue
                                } else {
                                        /* R:NO, G:NO, B:NO */
                                        result = .black
                                }
                        }
                }
                return result
        }*/
}


