/*
 * @file MIURL.swift
 * @description Extend URL class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import Foundation

public extension URL
{
        func isAbsolutePath() -> Bool {
            guard self.isFileURL else {
                return false
            }
            return self.path.hasPrefix("/")
        }

        func loadText() -> Result<String, NSError> {
                do {
                        let text = try String(contentsOf: self, encoding: .utf8)
                        return .success(text)
                } catch {
                        return .failure(MIError.error(
                                errorCode: .fileError,
                                message: "Failed to load from URL \(self.path)"))
                }
        }
}
