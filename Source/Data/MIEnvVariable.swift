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
        public static let debugMode             = "DEBUG"
        public static let home                  = "HOME"
        public static let paths                 = "PATH"
        public static let terminalRowNumber     = "LINES"
        public static let terminalColumnNumber  = "COLUMNS"

        public static let TrueValue             = "true"
        public static let FalseValue            = "false"

        public enum EnvValue {
                case bool(Bool)
                case string(String)
                case strings(Array<String>)
                case url(URL)
                case number(NSNumber)

                public func encode() -> String {
                        let result: String
                        switch self {
                        case .bool(let flag):           result = flag ? TrueValue : FalseValue
                        case .string(let str):          result = str
                        case .strings(let strs):        result = strs.joined(separator: ":")
                        case .url(let url):             result = url.path
                        case .number(let val):          result = "\(val)"
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

        public func encode() -> [String:String] {
                var result: [String:String] = [:]
                for (key, val) in mDictionary {
                        result[key] = val.encode()
                }
                return result
        }

        public var allKeys: Array<String> { get {
                return Array(mDictionary.keys.sorted())
        }}

        /* native value */
        public func value(for key: String) -> EnvValue? {
                return mDictionary[key]
        }

        public func set(value val: EnvValue, for key: String) {
                mDictionary[key] = val
        }

        /* Boolean */
        public func bool(forKey key: String) -> Bool? {
                if let val = mDictionary[key] {
                        let result: Bool?
                        switch val {
                        case .bool(let flag):   result = flag
                        default:                result = nil
                        }
                        return result
                } else {
                        return nil
                }
        }

        public func set(bool flag: Bool, forKey key: String) {
                mDictionary[key] = .bool(flag)
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

        /* Strings */
        public func strings(forKey key: String) -> Array<String>? {
                if let val = mDictionary[key] {
                        let result: Array<String>?
                        switch val {
                        case .strings(let strs):        result = strs
                        default:                        result = nil
                        }
                        return result
                } else {
                        return nil
                }
        }

        public func set(strings str: Array<String>, forKey key: String) {
                mDictionary[key] = .strings(str)
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

        /* URL */
        public func url(forKey key: String) -> URL? {
                if let val = mDictionary[key] {
                        let result: URL?
                        switch val {
                        case .url(let u):       result = u
                        default:                result = nil
                        }
                        return result
                } else {
                        return nil
                }
        }

        public func set(url path: URL, forKey key: String) {
                mDictionary[key] = .url(path)
        }
}

extension MIEnvVariables
{
        public func setDebugMode(_ flag: Bool) {
                set(bool: flag, forKey: MIEnvVariables.debugMode)
        }

        public func debugMode() -> Bool {
                if let flag = self.bool(forKey: MIEnvVariables.debugMode) {
                        return flag
                } else {
                        return false
                }
        }

        public func fileNameToExecutableCommandPath(fileName fname: String) -> Result<URL, NSError> {
                /* check the given path is absolute */
                if let c = fname.first {
                        if c == "/" {
                                if FileManager.default.isExecutableFile(atPath: fname) {
                                        return .success(URL(filePath: fname))
                                }
                        }
                } else {
                        return .failure(MIError.fileError(message: "No file name"))
                }
                if let paths = self.strings(forKey: MIEnvVariables.paths) {
                        for pathstr in paths {
                                let dirpath = URL(filePath: pathstr)
                                let cmdpath = dirpath.appendingPathComponent(fname)
                                if FileManager.default.isExecutableFile(atPath: cmdpath.path) {
                                        return .success(cmdpath)
                                }
                        }
                }
                return .failure(MIError.fileError(message: "File named \"\(fname)\" is NOT executable"))
        }
}

