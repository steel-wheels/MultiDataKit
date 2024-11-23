/*
 * @file MIValue.swift
 * @description Define MIValue data structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public indirect enum MIValueType {
        case boolean
        case uint
        case int
        case float
        case string
        case array(MIValueType)
        case dictionary(MIValueType) // key is string
        case interface(String?, Dictionary<String, MIValueType>)

        public var elementType: MIValueType? { get {
                switch self {
                case .array(let elmtype):       return elmtype
                case .dictionary(let elmtype):  return elmtype
                default:                        return nil
                }
        }}

        public var interfaceName: String? { get {
                switch self {
                case .interface(let name, _):   return name
                default:                        return nil
                }
        }}

        public func toString() -> String {
                let result: String
                switch self {
                case .boolean:          result = "boolean"
                case .uint:             result = "uint"
                case .int:              result = "int"
                case .float:            result = "float"
                case .string:           result = "string"
                case .array(let etype):
                        result = etype.toString() + "[]"
                case .dictionary(let etype):
                        result = "{ [key: string]: " + etype.toString() + "}"
                case .interface(let name, _):
                        let intf = name ?? "null"
                        result = "{ interface:\(intf) }"
                }
                return result
        }

        public static func isSame(type0 t0: MIValueType, type1 t1: MIValueType) -> Bool {
                var result: Bool = false
                switch t0 {
                case boolean:
                        switch t1 {
                        case boolean:   result = true
                        default:        break
                        }
                case uint:
                        switch t1 {
                        case uint:      result = true
                        default:        break
                        }
                case int:
                        switch t1 {
                        case int:       result = true
                        default:        break
                        }
                case float:
                        switch t1 {
                        case float:     result = true
                        default:        break
                        }
                case string:
                        switch t1 {
                        case string:    result = true
                        default:        break
                        }
                case .array(let e0):
                        switch t1 {
                        case .array(let e1):    result = MIValueType.isSame(type0: e0, type1: e1)
                        default:                break
                        }
                case .dictionary(let e0):
                        switch t1 {
                        case .dictionary(let e1):    result = MIValueType.isSame(type0: e0, type1: e1)
                        default:                break
                        }
                case .interface(let name0, let dict0):
                        switch t1 {
                        case .interface(let name1, let dict1):
                                if name0 == nil && name1 == nil {
                                        result = true
                                } else if let n0 = name0, let n1 = name1 {
                                        if n0 == n1 {
                                                result = isSame(types0: dict0, types1: dict1)
                                        }
                                }
                        default:                break
                        }
                }
                return result
        }

        private static func isSame(types0 t0: Array<MIValueType>, types1 t1: Array<MIValueType>) -> Bool {
                var result = false
                let num0 = t0.count ; let num1 = t1.count
                if num0 == num1 {
                        result = true
                        for i in 0..<num0 {
                                if !isSame(type0: t0[i], type1: t1[i]) {
                                        result = false
                                        break
                                }
                        }
                }
                return result
        }

        private static func isSame(types0 t0: Dictionary<String, MIValueType>, types1 t1: Dictionary<String, MIValueType>) -> Bool {
                guard t0.count == t1.count else {
                        return false
                }
                for (key0, type0) in t0 {
                        if let type1 = t1[key0] {
                                if !isSame(type0: type0, type1: type1) {
                                    return false
                                }
                        } else {
                                return false
                        }
                }
                return true
        }

        public static func union(type0 t0: MIValueType, type1 t1: MIValueType) -> MIValueType? {
                if isSame(type0: t0, type1: t1) {
                        return t0
                }
                var result: MIValueType? = nil
                switch t0 {
                case .uint:
                        switch t1 {
                        case .uint:     result = .uint
                        case .int:      result = .int
                        case .float:    result = .float
                        default:
                                break
                        }
                case .int:
                        switch t1 {
                        case .uint:     result = .int
                        case .int:      result = .int
                        case .float:    result = .float
                        default:
                                break
                        }
                case .float:
                        switch t1 {
                        case .uint:     result = .float
                        case .int:      result = .float
                        case .float:    result = .float
                        default:
                                break
                        }
                case .interface(let name0, _):
                        switch t1 {
                        case .interface(let name1, _):
                                if name0 == nil && name1 == nil {
                                        result = t0
                                } else if let n0 = name0, let n1 = name1 {
                                        if n0 == n1 {
                                                result = t0
                                        }
                                }
                        default:
                                break
                        }
                default:
                        break
                }
                return result
        }
}

public indirect enum MIValueBody {
        case boolean(Bool)
        case uint(UInt)
        case int(Int)
        case float(Double)
        case string(String)
        case array(Array<MIValue>)
        case dictionary(Dictionary<String, MIValue>) // key is string
        case interface(Dictionary<String, MIValue>)
}

public struct MIValue {
        public var      type:  MIValueType
        public var      value: MIValueBody

        public init(type: MIValueType, value: MIValueBody) {
                self.type = type
                self.value = value
        }

        public var booleanValue: Bool? { get {
                switch self.value {
                case .boolean(let val): return val
                default:                return nil
                }
        }}

        public var uintValue: UInt? { get {
                switch self.value {
                case .uint(let val):    return val
                default:                return nil
                }
        }}

        public var intValue: Int? { get {
                switch self.value {
                case .int(let val):     return val
                default:                return nil
                }
        }}

        public var floatValue: Double? { get {
                switch self.value {
                case .float(let val):   return val
                default:                return nil
                }
        }}

        public var stringValue: String? { get {
                switch self.value {
                case .string(let val):  return val
                default:                return nil
                }
        }}

        public var arrayValue: Array<MIValue>? { get {
                switch self.value {
                case .array(let val):   return val
                default:                return nil
                }
        }}

        public var dictionaryValue: (Dictionary<String, MIValue>)? { get {
                switch self.value {
                case .dictionary(let val):      return val
                default:                        return nil
                }
        }}

        public var interfaceyValue: (Dictionary<String, MIValue>)? { get {
                switch self.value {
                case .interface(let val):       return val
                default:                        return nil
                }
        }}

        public func cast(to dsttype: MIValueType) -> MIValue? {
                let result: MIValue?
                switch self.value {
                case .boolean(let value):
                        switch dsttype {
                        case .boolean:  result = self
                        case .uint:     result = MIValue.uintValue(value ? 1 : 0)
                        case .int:      result = MIValue.intValue(value ? 1 : 0)
                        default:        result = nil
                        }
                case .uint(let value):
                        switch dsttype {
                        case .boolean:  result = MIValue.booleanValue(value != 0)
                        case .uint:     result = self
                        case .int:      result = MIValue.intValue(Int(value))
                        case .float:    result = MIValue.floatValue(Double(value))
                        default:        result = nil
                        }
                case .int(let value):
                        switch dsttype {
                        case .boolean:  result = MIValue.booleanValue(value != 0)
                        case .uint:     result = MIValue.uintValue(UInt(value))
                        case .int:      result = self
                        case .float:    result = MIValue.floatValue(Double(value))
                        default:        result = nil
                        }
                case .float(let value):
                        switch dsttype {
                        case .boolean:  result = MIValue.booleanValue(value != 0.0)
                        case .uint:     result = MIValue.uintValue(UInt(value))
                        case .int:      result = MIValue.intValue(Int(value))
                        case .float:    result = self
                        default:        result = nil
                        }
                case .string(_):
                        switch dsttype {
                        case .string:   result = self
                        default:        result = nil
                        }
                case .array(let values):
                        if let srcelm = self.type.elementType {
                                switch dsttype {
                                case .array(let dstelm):
                                        if MIValueType.isSame(type0: srcelm, type1: dstelm) {
                                                result = self
                                        } else {
                                                var dstvals: Array<MIValue> = []
                                                for srcval in values {
                                                        if let dstval = srcval.cast(to: dstelm) {
                                                                dstvals.append(dstval)
                                                        } else {
                                                                NSLog("[Error] Failed to cast")
                                                        }
                                                }
                                                result = MIValue.arrayValue(elementType: dstelm, values: dstvals)
                                        }
                                default: result = nil
                                }
                        } else {
                                NSLog("[Error] Failed to get element type")
                                result = nil
                        }
                case .dictionary(let values):
                        if let srcelm = self.type.elementType {
                                switch dsttype {
                                case .dictionary(let dstelm):
                                        if MIValueType.isSame(type0: srcelm, type1: dstelm) {
                                                result = self
                                        } else {
                                                var dstvals: Dictionary<String, MIValue> = [:]
                                                for (srckey, srcval) in values {
                                                        if let dstval = srcval.cast(to: dstelm) {
                                                                dstvals[srckey] = dstval
                                                        } else {
                                                                NSLog("[Error] Failed to cast")
                                                        }
                                                }
                                                result = MIValue.dictionaryValue(elementType: dstelm, values: dstvals)
                                        }
                                default: result = nil
                                }
                        } else {
                                NSLog("[Error] Failed to get element type")
                                result = nil
                        }
                case .interface(_):
                        if MIValueType.isSame(type0: self.type, type1: dsttype) {
                                result = self
                        } else {
                                NSLog("[Error] Can not cast interface value")
                                result = nil
                        }
                }
                return result
        }

        public func toString(withType wtype: Bool) -> String {
                let valstr: String
                switch self.value {
                case .boolean(let value):       valstr = "\(value)"
                case .uint(let value):          valstr = "\(value)"
                case .int(let value):           valstr = "\(value)"
                case .float(let value):         valstr = "\(value)"
                case .string(let value):        valstr = "\"" + value + "\""
                case .array(let values):
                        var is1st = true
                        var str   = "["
                        for value in values {
                                if is1st {
                                        is1st = false
                                } else {
                                        str += ", "
                                }
                                str += value.toString(withType: wtype)
                        }
                        str += "]"
                        valstr = str
                case .dictionary(let values):
                        valstr = MIValue.toString(dictionary: values, withType: wtype)
                case .interface(let values):
                        valstr = MIValue.toString(dictionary: values, withType: wtype)
                }

                let result: String
                if wtype {
                        result = "(" + self.type.toString() + ") " + valstr
                } else {
                        result = valstr
                }
                return result
        }

        private static func toString(dictionary dict: Dictionary<String, MIValue>, withType wtype: Bool) -> String {
                var is1st = true
                var str   = "{"
                let keys =  dict.keys.sorted()
                for key in keys {
                        if is1st {
                                is1st = false
                        } else {
                                str += ", "
                        }
                        str += key + ":"
                        if let val = dict[key] {
                                str += val.toString(withType: wtype)
                        } else {
                                str += "?"
                        }
                }
                str += "}"
                return str
        }

        public static func adjustValueTypes(values: Array<MIValue>) -> Result<(MIValueType, Array<MIValue>), NSError> {
                NSLog("ELEMENT: {")
                for val in values {
                        NSLog("Element: " + val.toString(withType: true))
                }
                NSLog("ELEMENT: }")
                guard values.count > 0 else {
                        NSLog("SKIP")
                        return .success((.boolean, [])) // empty array
                }

                /* get unioned type */
                var utype: MIValueType = values[0].type
                for i in 1..<values.count {
                        if let type = MIValueType.union(type0: utype, type1: values[i].type) {
                                utype = type
                        } else {
                                let err = MIError.parseError(message: "Failed to get unioned type", line: 0)
                                return .failure(err)
                        }
                }

                /* get unioned value */
                var uvalues: Array<MIValue> = []
                for i in 0..<values.count {
                        if let val = values[i].cast(to: utype) {
                                uvalues.append(val)
                        } else {
                                let err = MIError.parseError(message: "Failed to cast to unioned data", line: 0)
                                return .failure(err)
                        }
                }

                return .success((utype, uvalues))
        }

        public static func booleanValue(_ value: Bool) -> MIValue {
                return MIValue(type: .boolean, value: .boolean(value))
        }

        public static func uintValue(_ value: UInt) -> MIValue {
                return MIValue(type: .uint, value: .uint(value))
        }

        public static func intValue(_ value: Int) -> MIValue {
                return MIValue(type: .int, value: .int(value))
        }

        public static func floatValue(_ value: Double) -> MIValue {
                return MIValue(type: .float, value: .float(value))
        }

        public static func stringValue(_ value: String) -> MIValue {
                return MIValue(type: .string, value: .string(value))
        }

        public static func arrayValue(elementType: MIValueType, values: Array<MIValue>) -> MIValue {
                return MIValue(type: .array(elementType), value: .array(values))
        }

        public static func dictionaryValue(elementType: MIValueType, values: Dictionary<String, MIValue>) -> MIValue {
                return MIValue(type: .dictionary(elementType), value: .dictionary(values))
        }

        public static func interfaceValue(name: String?, values: Dictionary<String, MIValue>) -> MIValue {
                var valtypes: Dictionary<String, MIValueType> = [:]
                for (ident, value) in values {
                        valtypes[ident] = value.type
                }
                let iftype: MIValueType = .interface(name, valtypes)
                return MIValue(type: iftype, value: .interface(values))
        }
}
