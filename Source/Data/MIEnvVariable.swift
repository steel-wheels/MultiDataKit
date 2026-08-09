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
        private var mDictionary:                Dictionary<String, String>
        private var mParentEnvVariable:         MIEnvVariables?

        public init(parent par: MIEnvVariables?) {
                mDictionary             = [:]
                mParentEnvVariable      = par
        }

        public func value(for key: String) -> String? {
                return mDictionary[key]
        }

        public func set(value val: String, for key: String) {
                mDictionary[key] = val
        }

        public func reset(for key: String) {
                mDictionary[key] = nil
        }

        public var allKeys: Array<String> { get {
                return Array(mDictionary.keys.sorted())
        }}

        public func encode() -> [String:String] {
                return mDictionary
        }
}

extension MIEnvVariables
{
        public static let debugModeVariable             = "DEBUG"
        public static let homeVariable                  = "HOME"
        public static let currentDirctoryVariable       = "PWD"
        public static let pathVariable                  = "PATH"
        public static let rowVariable                   = "ROW"
        public static let columnVariable                = "COLUMN"

        public var debugMode: Bool {
                get {
                        self.boolValue(for: MIEnvVariables.debugModeVariable)
                }
                set(val){
                        self.set(boolValue: val, for: MIEnvVariables.debugModeVariable)
                }
        }

        public var home: URL? {
                get {
                        return self.urlValue(for: MIEnvVariables.pathVariable)
                }
                set(path) {
                        self.set(urlValue: path, for: MIEnvVariables.pathVariable)
                }
        }

        public var currentDirectory: URL? {
                get {
                        return self.urlValue(for: MIEnvVariables.currentDirctoryVariable)
                }
                set(path) {
                        self.set(urlValue: path, for: MIEnvVariables.currentDirctoryVariable)
                }
        }

        public var paths: Array<URL> {
                get {
                        guard let str = self.value(for: MIEnvVariables.pathVariable) else {
                                return []
                        }
                        var result: Array<URL> = []
                        let substrs = str.components(separatedBy: ":")
                        for substr in substrs {
                                result.append(URL(fileURLWithPath: substr))
                        }
                        return result
                }
                set(arr){
                        let pnum = arr.count
                        if pnum > 0 {
                                var result = arr[0].path()
                                for i in 1 ..< pnum {
                                        result += ":" + arr[i].path()
                                }
                                self.set(value: result, for: MIEnvVariables.pathVariable)
                        } else {
                                self.set(value: "", for: MIEnvVariables.pathVariable)
                        }
                }
        }

        public var row: Int? {
                get      {
                        return intValue(for: MIEnvVariables.rowVariable)
                }
                set(val) {
                        if let v = val {
                                self.set(intValue: v, for: MIEnvVariables.rowVariable)
                        } else {
                                self.reset(for: MIEnvVariables.rowVariable)
                        }
                }
        }

        public var column: Int? {
                get      {
                        return intValue(for: MIEnvVariables.columnVariable)
                }
                set(val) {
                        if let v = val {
                                self.set(intValue: v, for: MIEnvVariables.columnVariable)
                        } else {
                                self.reset(for: MIEnvVariables.columnVariable)
                        }
                }
        }

        private func intValue(for key: String) -> Int? {
                if let str = mDictionary[key] {
                        return Int(str)
                } else {
                        return nil
                }
        }

        public func set(intValue val: Int, for key: String) {
                mDictionary[key] = String(val)
        }

        private func boolValue(for key: String) -> Bool {
                return self.value(for: key) != nil
        }

        public func set(boolValue val: Bool, for key: String) {
                if val {
                        self.set(value: "1", for: key)
                } else {
                        self.reset(for: key)
                }
        }

        private func urlValue(for key: String) -> URL? {
                if let path = self.value(for: key) {
                        return URL(filePath: path)
                } else {
                        return nil
                }
        }

        public func set(urlValue val: URL?, for key: String) {
                if let url = val {
                        self.set(value: url.path, for: key)
                } else {
                        self.reset(for: key)
                }
        }
}
