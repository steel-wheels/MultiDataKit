/*
 * @file MIJsonFile.swift
 * @description Define MIJson class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public class MIJsonFile
{
        public static func load(from url: URL) -> Result<MIValue, NSError> {
                switch loadText(from: url) {
                case .success(let text):
                        switch load(string: text) {
                        case .success(let val):
                                return .success(val)
                        case .failure(let err):
                                return .failure(err)
                        }
                case .failure(let err):
                        return .failure(err)
                }
        }

        public static func load(string str: String) -> Result<MIValue, NSError> {
                let stream = MIStringStream(string: str)
                switch MITokenizer.tokenize(stream: stream) {
                case .success(let tokens):
                        switch MIJsonDecoder.parse(tokens: tokens) {
                        case .success(let value):
                                return .success(value)
                        case .failure(let err):
                                return .failure(err)
                        }
                case .failure(let err):
                        return .failure(err)
                }
        }

        public static func save(value src: MIValue, to url: URL) -> NSError? {
                let text = MIJsonEncoder.encode(value: src)
                let str  = text.toString()
                do {
                        try str.write(to: url, atomically: false, encoding: .utf8)
                        return nil
                } catch {
                        return MIError.error(errorCode: .fileError, message: "Failed to save info URL: \(url.path)")
                }
        }

        public static func loadText(from url: URL) -> Result<String, NSError> {
                do {
                        let text = try String(contentsOf: url, encoding: .utf8)
                        return .success(text)
                } catch {
                        return .failure(MIError.error(errorCode: .fileError,
                                                      message: "Failed to load from URL \(url.path)"))
                }
        }
}
