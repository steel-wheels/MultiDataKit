/*
 * @file MIErrorCode.swift
 * @description Define MIErrorCode type
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation
import Darwin

public enum MIErrorCode {
        case unknownError
        case badFile
        case iinvalidParameter
        case noTTY

        public var code: Int32 {
                let result: Int32
                switch self {
                case .unknownError:             result = -1
                case .badFile:                  result = EBADF
                case .iinvalidParameter:        result = EINVAL
                case .noTTY:                    result = ENOTTY
                }
                return result
        }

        public var description: String { get {
                let result: String
                switch self {
                case .unknownError:             result = "unknown error"
                case .badFile:                  result = "bad file"
                case .iinvalidParameter:        result = "invalid param"
                case .noTTY:                    result = "no TTY"
                }
                return result
        }}

        public static func encode(_ val: Int32) -> MIErrorCode? {
                let result: MIErrorCode?
                switch val {
                case 0:         result = nil
                case EBADF:     result = .badFile
                case EINVAL:    result = .iinvalidParameter
                case ENOTTY:    result = .noTTY
                default:        result = .unknownError
                }
                return result
        }
}

