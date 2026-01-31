/*
 * @file MIFileHandle.swift
 * @description Define MIFileHandle structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public extension FileHandle
{
        func write(string src: String) {
                do {
                        if let data = src.data(using: .utf8) {
                                try self.write(contentsOf: data)
                        } else {
                                NSLog("[Error] Failed to make data at \(#file)")
                        }
                } catch {
                        NSLog("[Error] Exception occured at \(#file)")
                }
        }
}
