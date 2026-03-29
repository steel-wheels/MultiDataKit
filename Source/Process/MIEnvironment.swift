/*
 * @file MIEnvironment.swift
 * @description Define MIEnvironmentVariable class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

public class MIEnvironment
{
        public enum VariableName: String {
                case currentDictory     = "CURDIR"
        }

        private var mDictionary: NSMutableDictionary

        public init() {
                mDictionary = NSMutableDictionary(capacity: 32)
        }

        public var allNames: Array<NSString> { get {
                if let keys = mDictionary.allKeys as? Array<NSString> {
                        return keys
                } else {
                        NSLog("[Error] Failed to get key at \(#file)")
                        return []
                }
        }}

        public func set(name nm: String, value val: NSString?) {
                mDictionary[nm] = val
        }

        public func get(name nm: String) -> NSString? {
                return mDictionary[nm] as? NSString
        }

        public var currentDirectory: URL? {
                get {
                        let ename = VariableName.currentDictory.rawValue
                        if let path = get(name: ename) {
                                return URL(filePath: String(path))
                        } else {
                                return nil
                        }
                }
                set(urlp) {
                        let ename = VariableName.currentDictory.rawValue
                        if let url = urlp {
                                let path = NSString(string: url.path())
                                set(name: ename, value: path)
                        } else {
                                set(name: ename, value: nil)
                        }
                }
        }
}
