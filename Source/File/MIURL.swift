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
}
