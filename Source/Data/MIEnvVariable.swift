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

public enum MIColorEnvName: String
{
        case terminalForeground    = "TFCOLOR"
        case terminalBackground    = "TBCOLOR"
}

public class MIEnvVariables
{
        private var mDictionary:                NSMutableDictionary
        private var mParentEnvVariable:         MIEnvVariables?

        public init(parent par: MIEnvVariables?) {
                mDictionary             = NSMutableDictionary(capacity: 32)
                mParentEnvVariable      = par
        }

        public var allNames: Set<String> { get {
                var result: Set<String>
                if let parent = mParentEnvVariable {
                        result = parent.allNames
                } else {
                        result = []
                }
                if let keys = mDictionary.allKeys as? Array<String> {
                        result = result.union(keys)
                }
                return result
        }}

        public func object(forKey key: String) -> NSObject? {
                if let obj = mDictionary.value(forKey: key) as? NSObject {
                        return obj
                } else {
                        if let parent = mParentEnvVariable {
                                return parent.object(forKey: key)
                        } else {
                                return nil
                        }
                }
        }

        public func set(object obj: NSObject, forKey key: String) {
                mDictionary.setObject(obj, forKey: key as NSCopying)
        }

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

        /* String */
        public func string(forKey key: String) -> String? {
                if let str = object(forKey: key) as? String {
                        return str
                } else {
                        return nil
                }
        }

        public func set(string str: String, forKey key: String) {
                mDictionary.setObject(str, forKey: key as NSCopying)
        }

        /* Array<Int> */
        public func intArray(forKey key: String) -> Array<Int>? {
                if let arr = object(forKey: key) as? NSArray {
                        var result: Array<Int> = []
                        for i in 0..<arr.count {
                                if let elm = arr.object(at: i) as? NSNumber {
                                        result.append(elm.intValue)
                                } else {
                                        NSLog("[Error] Failed to convert to number at \(#file)")
                                        return nil
                                }
                        }
                        return result
                } else {
                        return nil
                }
        }

        public func set(intArray vals: Array<Int>, forKey key: String) {
                let arr = NSMutableArray(capacity: vals.count)
                for val in vals {
                        arr.add(NSNumber(value: val))
                }
                set(object: arr, forKey: key)
        }

        /* Number */
        public func number(forKey key: String) -> NSNumber? {
                if let num = object(forKey: key) as? NSNumber {
                        return num
                } else {
                        return nil
                }
        }

        public func set(number num: NSNumber, forKey key: String) {
                mDictionary.setObject(num, forKey: key as NSCopying)
        }

        /* text color */
        public func color(forKey key: MIColorEnvName) -> MITextColor? {
                if let val = intArray(forKey: key.rawValue) {
                        if let col = MITextColor.decode(colorCodes: val) {
                                return col
                        }
                }
                return nil
        }

        public func set(color col: MITextColor, forKey key: MIColorEnvName) {
                set(intArray: col.encode(), forKey: key.rawValue)
        }
}
