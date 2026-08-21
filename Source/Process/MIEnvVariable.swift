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

        public var dictionaryValue: Dictionary<String, String> { get {
                return mDictionary
        }}

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

        public func encode() -> MIValue {
                var value: Dictionary<String, MIValue> = [:]
                for (key, val) in mDictionary {
                        value[key] = MIValue(stringValue: val)
                }
                return MIValue(dictionaryValue: value)
        }

        public func decode(value src: MIValue) -> NSError? {
                guard let dict = src.dictionaryValue else {
                        let err = MIError.parseError(message: "Dictionary value is required", line: 0)
                        return err
                }
                for (key, val) in dict {
                        if let str = val.stringValue {
                                set(value: str, for: key)
                        } else {
                                let err = MIError.parseError(message: "Dictionary member must be string", line: 0)
                                return err
                        }
                }
                return nil
        }
}

extension MIEnvVariables
{
        public static let backgroundColorVariable       = "BGCOL"
        public static let debugModeVariable             = "DEBUG"
        public static let foregroundColorVariable       = "FGCOL"
        public static let homeVariable                  = "HOME"
        public static let currentDirctoryVariable       = "PWD"
        public static let searchPathVariable            = "PATH"
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
                        return self.urlValue(for: MIEnvVariables.homeVariable)
                }
                set(path) {
                        self.set(urlValue: path, for: MIEnvVariables.homeVariable)
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

        public var searchPaths: Array<URL> {
                get {
                        guard let str = self.value(for: MIEnvVariables.searchPathVariable) else {
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
                                self.set(value: result, for: MIEnvVariables.searchPathVariable)
                        } else {
                                self.set(value: "", for: MIEnvVariables.searchPathVariable)
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

        public var foregroundColor: MITextColor? {
                get      {
                        return colorValue(for: MIEnvVariables.foregroundColorVariable)
                }
                set(val) {
                        if let v = val {
                                self.set(colorValue: v, for: MIEnvVariables.foregroundColorVariable)
                        } else {
                                self.reset(for: MIEnvVariables.foregroundColorVariable)
                        }
                }
        }

        public var backgroundColor: MITextColor? {
                get      {
                        return colorValue(for: MIEnvVariables.backgroundColorVariable)
                }
                set(val) {
                        if let v = val {
                                self.set(colorValue: v, for: MIEnvVariables.backgroundColorVariable)
                        } else {
                                self.reset(for: MIEnvVariables.backgroundColorVariable)
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

        private func colorValue(for key: String) -> MITextColor? {
                if let val = self.value(for: key) {
                        return MITextColor.decode(name: val)
                } else {
                        return nil
                }
        }

        public func set(colorValue val: MITextColor?, for key: String) {
                if let col = val {
                        self.set(value: col.name, for: key)
                } else {
                        self.reset(for: key)
                }
        }
}

extension MIEnvVariables
{
        public func loadDefaults(forClass cls: AnyClass) -> NSError? {
                guard let resdir  = FileManager.default.resourceDirectory(forClass: cls) else {
                        let err = MIError.fileError(message: "No resource directory")
                        return err
                }
                let deffile = resdir.appending(path: "Library/defaults.json")
                switch MIJsonFile.load(from: deffile) {
                case .success(let val):
                        return self.decode(value: val)
                case .failure(let err):
                        return err
                }
        }
}

