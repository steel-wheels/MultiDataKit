/*
 * @file MIText.swift
 * @description Define MIText classes
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public enum MITextType {
        case word
        case line
        case lines
}

public protocol MIText
{
        var type: MITextType { get }
        func toString() -> String
}

public extension MIText {
        func generate(from texts: Array<MIText>) -> MIText {
                var words: Array<KSWord> = []
                var lines: Array<KSLine> = []
                let result: KSLines = KSLines()

                for text in texts {
                        switch text.type {
                        case .word:
                                if let word = text as? KSWord {
                                        words.append(word)
                                } else {
                                        NSLog("Can not happen: word")
                                }
                        case .line:
                                if let line = flush(words: words) {
                                        lines.append(line) ; words = []
                                }
                                if let line = text as? KSLine {
                                        lines.append(line)
                                } else {
                                        NSLog("Can not happen: line")
                                }
                        case .lines:
                                if let line = flush(words: words) {
                                        lines.append(line) ; words = []
                                }
                                for line in lines {
                                        result.append(line: line)
                                }
                        }
                }
                if let line = flush(words: words) {
                        lines.append(line) ; words = []
                }
                for line in lines {
                        result.append(line: line)
                }
                return result
        }

        private func flush(words: Array<KSWord>) -> KSLine? {
                if words.count > 0 {
                        return KSLine(words: words)
                } else {
                        return nil
                }
        }
}

public class KSWord: MIText
{
        private var mString: String

        public var type: MITextType { get { return .word }}

        public init(word: String) {
                mString = word
        }

        public func toString() -> String {
                return mString
        }
}

public class KSLine: MIText
{
        private var mWords: Array<KSWord>

        public var type: MITextType { get { return .line }}

        public init() {
                mWords = []
        }

        public init(words: Array<KSWord>){
                mWords = words
        }

        public func append(word: KSWord) {
                mWords.append(word)
        }

        public func toString() -> String {
                var result: String = ""
                var is1st = true
                for word in mWords {
                        if is1st { is1st = false } else { result += " "}
                        result += word.toString()
                }
                return result
        }
}

public class KSLines: MIText
{
        private var mLines: Array<KSLine>

        public var type: MITextType { get { return .lines }}

        public init(){
                mLines = []
        }

        public init(lines: Array<KSLine>){
                mLines = lines
        }

        public func append(line: KSLine) {
                mLines.append(line)
        }

        public func append(lines: KSLines) {
                mLines.append(contentsOf: lines.mLines)
        }

        public func toString() -> String {
                var result: String = ""
                var is1st = true
                for line in mLines {
                        if is1st { is1st = false } else { result += "\n" }
                        result += line.toString()
                }
                return result
        }
}


