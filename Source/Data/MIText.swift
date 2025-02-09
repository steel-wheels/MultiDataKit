/*
 * @file MIText.swift
 * @description Define MIText classes
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public enum MITextType {
        case line
        case paragraph
}

public struct MILineString {
        var indent:     Int
        var line:       String

        public init(indent: Int, line: String) {
                self.indent = indent
                self.line = line
        }

        public func append(string str: String) -> MILineString {
                return MILineString(indent: self.indent, line: self.line + str)
        }
}

public protocol MIText
{
        var type: MITextType { get }
        func append(text txt: MIText)
        func append(string str: String)
        func prepend(string str: String)
        func toLineStrings(indent idt: Int) -> Array<MILineString>
}

public extension MIText
{
        func indentString(indent idt: Int) -> String {
                let space: String = "\t"
                var result = ""
                for _ in 0..<idt {
                        result += space
                }
                return result
        }

        func toString() -> String {
                let lines = self.toLineStrings(indent: 0)
                var result: String = ""
                for line in lines {
                        let newstr = indentString(indent: line.indent)
                                   + line.line + "\n"
                        result += newstr
                }
                return result
        }
}

public class MILine: MIText
{
        private var mLine: String

        public var type: MITextType { get { return .line }}

        public init() {
                mLine = ""
        }

        public init(line str: String){
                mLine = str
        }

        public func append(text txt: MIText) {
                if let line = txt as? MILine {
                        mLine = mLine + line.mLine
                } else {
                        NSLog("[Error] Failed to add \(#function)")
                }
        }

        public func append(string str: String) {
                mLine = mLine + str
        }

        public func prepend(string str: String) {
                mLine = str + mLine
        }

        public func append(word: MILine) {
                mLine.append(word.mLine)
        }

        public func toLineStrings(indent idt: Int) -> Array<MILineString> {
                return [ MILineString(indent: idt, line: mLine) ]
        }
}

public class MIParagraph: MIText
{
        private var mLines:   Array<MIText>

        public var prefix:  String?
        public var postfix: String?
        public var divider: String?

        public var type: MITextType { get { return .paragraph }}

        public init(){
                mLines  = []
                prefix  = nil
                postfix = nil
                divider = nil
        }

        public init(lines: Array<MILine>){
                mLines = lines
        }

        public func append(text txt: MIText) {
                mLines.append(txt)
        }

        public func append(string str: String) {
                if mLines.count > 0 {
                        mLines[mLines.count - 1].append(string: str)
                } else {
                        mLines.append(MILine(line: str))
                }
        }

        public func prepend(string str: String) {
                if let pstr = self.prefix {
                        self.prefix = str + pstr
                } else {
                        if mLines.count > 0 {
                                mLines[0].prepend(string: str)
                        } else {
                                mLines.append(MILine(line: str))
                        }
                }
        }

        public func add(text txt: MIText) {
                mLines.append(txt)
        }

        public func toLineStrings(indent idt: Int) -> Array<MILineString> {
                let childidt: Int
                if self.prefix == nil && self.postfix == nil {
                        childidt = idt
                } else {
                        childidt = idt + 1
                }

                var result: Array<MILineString> = []
                if let pstr = self.prefix {
                        result.append(MILineString(indent: idt, line: pstr))
                }

                for idx in 0..<mLines.count {
                        let line = mLines[idx]
                        var sublines = line.toLineStrings(indent: childidt)
                        /* append '"," to the if the lines */
                        if let delim = self.divider {
                                if idx < mLines.count - 1 && sublines.count > 0 {
                                        let lastline = sublines[sublines.count - 1]
                                        sublines[sublines.count - 1] = lastline.append(string: delim)
                                }
                        }
                        result.append(contentsOf: sublines)
                }

                if let pstr = self.postfix {
                        result.append(MILineString(indent: idt, line: pstr))
                }

                return result
        }
}


