/*
 * @file MIAttributedString.swift
 * @description Extend NSAttributedString class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import Foundation

public extension NSAttributedString
{
        func divideByNewline() -> Array<NSAttributedString> {
                var result: Array<NSAttributedString> = []
                var currentidx = 0
                let endidx     = self.length
                while currentidx < endidx {
                        if let nxtidx = self.searchString("\n", from: currentidx) {
                                let range  = NSRange(location: currentidx, length: nxtidx - currentidx)
                                let substr = self.attributedSubstring(from: range)
                                result.append(substr)
                                currentidx = nxtidx + 1
                        } else {
                                break
                        }
                }
                if currentidx < endidx {
                        let range  = NSRange(location: currentidx, length: endidx - currentidx)
                        let substr = self.attributedSubstring(from: range)
                        result.append(substr)
                }
                return result
        }

        private func searchString(_ src: String, from fromidx: Int) -> Int? {
                var idx:    Int    = fromidx
                let srclen: Int    = src.count
                while idx < self.length {
                        let range  = NSRange(location: idx, length: srclen)
                        let substr = self.attributedSubstring(from: range)
                        if substr.string == src {
                                return idx
                        }
                        idx += 1
                }
                return nil
        }

        func adjustLength(width maxwidth: Int, attribute attr: Dictionary<NSAttributedString.Key, Any>) -> NSAttributedString {
                if self.length > maxwidth {
                        let range = NSRange(location: 0, length: maxwidth)
                        return self.attributedSubstring(from: range)
                } else if self.length < maxwidth {
                        let result  = NSMutableAttributedString(attributedString: self)
                        let spaces  = String(repeating: " ", count: maxwidth - self.length)
                        let aspaces = NSMutableAttributedString(string: spaces, attributes: attr)
                        result.append(aspaces)
                        return result
                } else {
                        return self
                }
        }
}
