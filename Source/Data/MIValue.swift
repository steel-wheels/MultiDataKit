/*
 * @file MIValue.swift
 * @description Define MIValue data structure
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import Foundation

public enum MIValueType: Int
{
        case nilType            = 0
        case booleanType        = 1
        case signedIntType      = 2 // 32bit int
        case unsignedIntType    = 3 // 32bit unsigned int
        case floatType          = 4 // double
        case stringType         = 5 // NSString
        case arrayType          = 6
        case dictionaryType     = 7

        public var name: String { get {
                var result: String
                switch self {
                case .nilType:          result = "nil"
                case .booleanType:      result = "bool"
                case .unsignedIntType:  result = "uint"
                case .signedIntType:    result = "int"
                case .floatType:        result = "float"
                case .stringType:       result = "string"
                case .arrayType:        result = "array"
                case .dictionaryType:   result = "dictionary"
                }
                return result
        }}

        static func isNumberType(_ type: MIValueType) -> Bool {
                let result: Bool
                switch type {
                case signedIntType, unsignedIntType, floatType:
                        result = true
                case nilType, booleanType, stringType, arrayType, dictionaryType:
                        result = false
                }
                return result
        }

        static func union(src0: MIValueType, src1: MIValueType) -> MIValueType? {
                if(src0 == src1){
                        return src0
                } else if MIValueType.isNumberType(src0) && MIValueType.isNumberType(src1) {
                        if src0.rawValue >= src1.rawValue {
                                return src0
                        } else {
                                return src1
                        }
                }
                return nil
        }
}

public enum MIValueData
{
        case nilValue
        case booleanValue(Bool)
        case signedIntValue(Int)
        case unsignedIntValue(UInt)
        case floatValue(Double)
        case stringValue(String)
        case arrayValue(Array<MIValue>)
        case dictionaryValue(Dictionary<String, MIValue>)
}

public struct MIValue
{
        public var type        : MIValueType
        public var value       : MIValueData

        public init() {
                self.type       = .nilType
                self.value      = .nilValue
        }
        public init(booleanValue bval: Bool){
                self.type       = .booleanType
                self.value      = .booleanValue(bval)
        }

        public init(signedIntValue val: Int){
                self.type       = .signedIntType
                self.value      = .signedIntValue(val)
        }

        public init(unsignedIntValue val: UInt){
                self.type       = .unsignedIntType
                self.value      = .unsignedIntValue(val)
        }

        public init(floatValue val: Double){
                self.type       = .floatType
                self.value      = .floatValue(val)
        }

        public init(stringValue val: String){
                self.type       = .stringType
                self.value      = .stringValue(val)
        }

        public init(arrayValue val: Array<MIValue>){
                self.type       = .arrayType
                self.value      = .arrayValue(val)
        }

        public init(dictionaryValue val: Dictionary<String, MIValue>){
                self.type       = .dictionaryType
                self.value      = .dictionaryValue(val)
        }

        public var booleanValue: Bool? { get {
                switch(self.value){
                case .booleanValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public var signedIntValue: Int? { get {
                switch(self.value){
                case .signedIntValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public var unsignedIntValue: UInt? { get {
                switch(self.value){
                case .unsignedIntValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public var floatValue: Double? { get {
                switch(self.value){
                case .floatValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public var stringValue: String? { get {
                switch(self.value){
                case .stringValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public var arrayValue: Array<MIValue>? { get {
                switch(self.value){
                case .arrayValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public var dictionaryValue: Dictionary<String, MIValue>? { get {
                switch(self.value){
                case .dictionaryValue(let val):
                        return val
                default:
                        return nil
                }
        }}

        public func toObject() -> NSObject {
                var result: NSObject
                switch(self.value){
                case .nilValue:
                        result = NSNull()
                case .booleanValue(let val):
                        result = NSNumber(value: val)
                case .signedIntValue(let val):
                        result = NSNumber(value: val)
                case .unsignedIntValue(let val):
                        result = NSNumber(value: val)
                case .floatValue(let val):
                        result = NSNumber(value: val)
                case .stringValue(let val):
                        result = val as NSString
                case .arrayValue(let arr):
                        let newarray = NSMutableArray(capacity: 16)
                        for val in arr {
                                newarray.add(val.toObject())
                        }
                        result = newarray
                case .dictionaryValue(let dict):
                        let newdict = NSMutableDictionary(capacity: 16)
                        for (key, val) in dict {
                                newdict.setObject(val.toObject(), forKey: key as NSString)
                        }
                        result = newdict
                }
                return result
        }

        public func compare(_ src: MIValue) -> Int? {
                guard self.type == src.type else {
                        return nil
                }
                var result: Int? = nil
                switch src.type {
                case .nilType:
                        result = 0
                case .booleanType:
                        let selfv = self.booleanValue! ? 1 : 0
                        let srcv  = src.booleanValue!  ? 1 : 0
                        result = selfv - srcv
                case .signedIntType:
                        let selfv = self.signedIntValue!
                        let srcv  = self.signedIntValue!
                        if selfv > srcv {
                                result = 1
                        } else if selfv < srcv {
                                result = -1
                        } else {
                                result = 0
                        }
                case .unsignedIntType:
                        let selfv = self.unsignedIntValue!
                        let srcv  = self.unsignedIntValue!
                        if selfv > srcv {
                                result = 1
                        } else if selfv < srcv {
                                result = -1
                        } else {
                                result = 0
                        }
                case .floatType:
                        let selfv = self.floatValue!
                        let srcv  = self.floatValue!
                        if selfv > srcv {
                                result = 1
                        } else if selfv < srcv {
                                result = -1
                        } else {
                                result = 0
                        }
                case .stringType:
                        let selfv = self.stringValue!
                        let srcv  = self.stringValue!
                        if selfv > srcv {
                                result = 1
                        } else if selfv < srcv {
                                result = -1
                        } else {
                                result = 0
                        }
                case .arrayType:
                        let selfv = self.arrayValue!
                        let srcv  = self.arrayValue!

                        let selfc = selfv.count
                        let srcc  = selfv.count
                        if selfc != srcc {
                                return selfc - srcc
                        }

                        result = 0
                        for i in 0..<selfc {
                                if let res = selfv[i].compare(srcv[i]) {
                                        if res != 0 {
                                                result = res
                                                break
                                        }
                                } else {
                                        result = nil
                                        break
                                }
                        }
                case .dictionaryType:
                        let selfv = self.dictionaryValue!
                        let srcv  = self.dictionaryValue!

                        let selfc = selfv.count
                        let srcc  = selfv.count
                        if selfc != srcc {
                                return selfc - srcc
                        }

                        result = 0
                        for (key, elmv) in selfv {
                                if let elms = srcv[key] {
                                        if let res = elmv.compare(elms) {
                                                if res != 0 {
                                                        result = res
                                                        break
                                                }
                                        } else {
                                                result = nil
                                                break
                                        }
                                } else {
                                        result = nil
                                        break
                                }
                        }
                }
                return result
        }

        public func cast(to target: MIValueType) -> MIValue? {
                if self.type == target {
                        return self
                }
                let result: MIValue?
                switch self.value {
                case .unsignedIntValue(let val):
                        switch target {
                        case .unsignedIntType:
                                result = self
                        case .signedIntType:
                                result = MIValue(signedIntValue: Int(val))
                        case .floatType:
                                result = MIValue(floatValue: Double(val))
                        default:
                                result = nil
                        }
                case .signedIntValue(let val):
                        switch target {
                        case .unsignedIntType:
                                result = MIValue(unsignedIntValue: UInt(val))
                        case .signedIntType:
                                result = self
                        case .floatType:
                                result = MIValue(floatValue: Double(val))
                        default:
                                result = nil
                        }
                case .floatValue(let val):
                        switch target {
                        case .unsignedIntType:
                                result = MIValue(unsignedIntValue: UInt(val))
                        case .signedIntType:
                                result = MIValue(signedIntValue: Int(val))
                        case .floatType:
                                result = MIValue(floatValue: val)
                        default:
                                result = nil
                        }
                default:
                        result = nil
                }
                return result
        }

        public func toString() -> String {
                var result: String
                switch self.value {
                case .nilValue:                         result = "nil"
                case .booleanValue(let val):            result = "\(val)"
                case .unsignedIntValue(let val):        result = "\(val)"
                case .signedIntValue(let val):          result = "\(val)"
                case .floatValue(let val):              result = "\(val)"
                case .stringValue(let val):              result = "\"\(val)\""
                case .arrayValue(let values):
                        var str:   String = "["
                        var is1st: Bool   = true
                        for elm in values {
                                if is1st { is1st = false } else { str += ", "}
                                str += elm.toString()
                        }
                        str += "]"
                        result = str
                case .dictionaryValue(let dict):
                        var str:   String = "{"
                        var is1st: Bool   = true
                        for (key, val) in dict {
                                if is1st { is1st = false } else { str += ", "}
                                str += key + ":" + val.toString()
                        }
                        str += "}"
                        result = str
                }
                return result
        }

        public static func adjustValueTypes(values: Array<MIValue>) -> Result<(MIValueType, Array<MIValue>), NSError> {
                if values.count == 0 {
                        return .success((.nilType, []))
                } else if values.count == 1 {
                        let elm = values[0]
                        return .success((elm.type, [elm]))
                }
                // get unioned type of elements in array
                // values.count >= 2
                let elm         = values[0]
                var utype       = elm.type
                for i in 1..<values.count {
                        if let type = MIValueType.union(src0: utype, src1: values[i].type) {
                                utype = type
                        } else {
                                let name0 = utype.name
                                let name1 = values[i].type.name
                                let err = MIError.parseError(message: "Failed to get unioned type: \(name0) <-> \(name1)",line: 0)
                                return .failure(err)
                        }
                }
                // cast all elements
                var result: Array<MIValue> = []
                for elm in values {
                        if let newelm = elm.cast(to: utype) {
                                result.append(newelm)
                        } else {
                                let err = MIError.parseError(message: "Failed to cast element", line: 0)
                                return .failure(err)
                        }
                }
                return .success((utype, result))
        }

        public static func fromNumber(number num: NSNumber) -> MIValue {
                let result: MIValue
                let ecode = String(cString: num.objCType)
                switch ecode {
                case "c":       result = MIValue(signedIntValue: Int(num.int8Value))       // cchar
                case "i":       result = MIValue(signedIntValue: Int(num.int32Value))      // int
                case "s":       result = MIValue(signedIntValue: Int(num.int16Value))      // short
                case "l":       result = MIValue(signedIntValue: Int(num.int64Value))      // long
                case "q":       result = MIValue(signedIntValue: Int(num.int64Value))      // long
                case "I":       result = MIValue(unsignedIntValue: UInt(num.int32Value))   // int
                case "S":       result = MIValue(unsignedIntValue: UInt(num.int16Value))   // short
                case "L":       result = MIValue(unsignedIntValue: UInt(num.int64Value))   // long
                case "Q":       result = MIValue(unsignedIntValue: UInt(num.int64Value))   // long
                case "f":       result = MIValue(floatValue: Double(num.floatValue))       // float
                case "d":       result = MIValue(floatValue: num.doubleValue)              // doyble
                case "b":       result = MIValue(booleanValue: num.boolValue)              // doyble
                default:
                        NSLog("[Error] Failed to get value from number at \(#function)")
                        result = MIValue(floatValue: Double(num.floatValue))
                }
                return result
        }

        public static func fromObject(object obj: NSObject) -> MIValue {
                let result: MIValue
                if let _ = obj as? NSNull {
                        result = MIValue()
                } else if let num = obj as? NSNumber {
                        result = MIValue.fromNumber(number: num)
                } else if let str = obj as? NSString {
                        result = MIValue(stringValue: str as String)
                } else if let arr = obj as? NSArray {
                        var dst: Array<MIValue> = []
                        let count = arr.count
                        for i in 0..<count {
                                if let elm = arr.object(at: i) as? NSObject {
                                        dst.append(MIValue.fromObject(object: elm))
                                } else {
                                        NSLog("[Error] Failed to convert array element at \(#file)")
                                }
                        }
                        result = MIValue(arrayValue: dst)
                } else if let dict = obj as? NSDictionary {
                        var dst: Dictionary<String, MIValue> = [:]
                        for (key, elmp) in dict {
                                if let key = key as? String, let elm = elmp as? NSObject {
                                        dst[key] = MIValue.fromObject(object: elm)
                                } else {
                                        NSLog("[Error] Failed to convert dictionary element at \(#file)")
                                }
                        }
                        result = MIValue(dictionaryValue: dst)
                } else {
                        NSLog("[Error] Unknown data type at \(#file)")
                        result = MIValue()
                }
                return result
        }
}

public extension NSNumber
{
        var valueType: MIValueType { get {
                let result: MIValueType
                let ecode = String(cString: self.objCType)
                switch ecode {
                case "c", "i", "s", "l", "q":
                        result = .signedIntType
                case "C", "I", "S", "L", "Q":
                        result = .unsignedIntType
                case "f", "d":
                        result = .floatType
                case "b":
                        result = .booleanType
                default:
                        NSLog("[Error] Unknown type of NSNUmber")
                        result = .floatType
                }
                return result
        }}
}
