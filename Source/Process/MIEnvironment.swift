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

        public func set(name nm: String, object obj: NSObject?) {
                mDictionary[nm] = obj
        }

        public func get(name nm: String) -> NSObject? {
                return mDictionary[nm] as? NSObject
        }

        public var currentDirectory: URL? {
                get {
                        let ename = VariableName.currentDictory.rawValue
                        if let path = get(name: ename) as? NSString {
                                return URL(filePath: String(path))
                        } else {
                                return nil
                        }
                }
                set(urlp) {
                        let ename = VariableName.currentDictory.rawValue
                        if let url = urlp {
                                let path = NSString(string: url.path())
                                set(name: ename, object: path)
                        } else {
                                set(name: ename, object: nil)
                        }
                }
        }
}
