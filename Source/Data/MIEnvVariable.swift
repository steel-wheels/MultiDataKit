/*
 * @file MIEnvVariable.swift
 * @description Define MIEnvVariable class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)
import Foundation

public class MIEnvVariables
{
        public static let terminalRowNumber          = "LINES"
        public static let terminalColumnNumber       = "COLUMNS"

        public enum EnvValue {
                case string(String)
                case number(NSNumber)

                public func encode() -> String {
                        let result: String
                        switch self {
                        case .string(let str):     result = str
                        case .number(let val):     result = "\(val)"
                        }
                        return result
                }
        }

        private var mDictionary:                Dictionary<String, EnvValue>    // env-name, env-value
        private var mParentEnvVariable:         MIEnvVariables?

        public init(parent par: MIEnvVariables?) {
                mDictionary             = [:]
                mParentEnvVariable      = par
        }

        public var allNames: Set<String> { get {
                var result: Set<String>
                if let parent = mParentEnvVariable {
                        result = parent.allNames
                } else {
                        result = []
                }
                result = result.union(mDictionary.keys)
                return result
        }}

        public func encode() -> [String:String] {
                var result: [String:String] = [:]
                for name in self.allNames {
                        if let str = self.string(forKey: name) {
                                result[name] = str
                        } else {
                                NSLog("[Warning] Igore envvar name: \(name)")
                        }
                }
                return result
        }

        /* native value */
        public func value(for key: String) -> EnvValue? {
                return mDictionary[key]
        }

        public func set(value val: EnvValue, for key: String) {
                mDictionary[key] = val
        }

        /* String */
        public func string(forKey key: String) -> String? {
                if let val = mDictionary[key] {
                        let result: String?
                        switch val {
                        case .string(let str):  result = str
                        default:                result = nil
                        }
                        return result
                } else {
                        return nil
                }
        }

        public func set(string str: String, forKey key: String) {
                mDictionary[key] = .string(str)
        }

        /* Number */
        public func number(forKey key: String) -> NSNumber? {
                if let val = mDictionary[key] {
                        let result: NSNumber?
                        switch val {
                        case .number(let num):     result = num
                        default:                result = nil
                        }
                        return result
                } else {
                        return nil
                }
        }

        public func set(number num: NSNumber, forKey key: String) {
                mDictionary[key] = .number(num)
        }
}
