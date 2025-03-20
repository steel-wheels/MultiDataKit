/*
 * @file MICharacter.swift
 * @description Extend Character class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public extension Character
{
        static let newline: Character           = "\n"
        static let singleQuotation: Character   = "`"
        static let quotation: Character         = "\""
        static let backslash: Character         = "\\"
        static let tab: Character               = "\t"
        static let null: Character              = "\0"
        static let carriageReturn: Character    = "\r"

        /* Reference: http://jkorpela.fi/chars/c0.html */
        static let ETX          = Character("\u{03}")
        static let EOT          = Character("\u{04}")
        static let BEL          = Character("\u{07}")
        static let BS           = Character("\u{08}")
        static let TAB          = Character("\u{09}")
        static let LF           = Character("\u{0a}")
        static let VT           = Character("\u{0b}")
        static let CR           = Character("\u{0d}")
        static let ESC          = Character("\u{1b}")
        static let DEL          = Character("\u{7f}")

       var isFirstIdentifier: Bool { get {
               return self.isLetter || (self == "_")
        }}

        var isMiddleIdentifier: Bool { get {
                return self.isLetter || (self == "_") || self.isNumber
        }}
}

