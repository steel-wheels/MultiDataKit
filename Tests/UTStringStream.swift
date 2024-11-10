/*
 * @file UTStringStream.swift
 * @description Unit test for KSStringStream class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MultiDataKit_macOS
import Foundation

public func testStringStream() -> Bool
{
        var result = true
        let url  = URL(filePath: "data.json")
        do {
                let text = try String(contentsOf: url, encoding: .utf8)
                //print("test: \(text)")
                print("START")
                let stream = MIStringStream(string: text)
                //while let c = stream.getc() {
                //        print(c)
                //}
                /* Tokenize */
                switch MITokenizer.tokenize(stream: stream) {
                case .success(let tokens):
                        for token in tokens {
                                print(token.toString())
                        }
                        /* Paese as JSON */
                        switch MIJsonDecoder.parse(tokens: tokens) {
                        case .success(let jsonval):
                                let txt = MIJsonEncoder.encode(value: jsonval)
                                print("Encoded JSON: \(txt.toString())")
                        case .failure(let err):
                                print("[Error] " + MIError.errorToString(error: err))
                        }
                case .failure(let err):
                        print("[Error] " + MIError.errorToString(error: err))
                }
                print("END")
        } catch {
                print("[Error] Failed to load data")
                result = false
        }
        return result
}
