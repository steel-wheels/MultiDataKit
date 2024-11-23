/*
 * @file MIError.swift
 * @description Define MIError class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public func MILog(_ msg: String, file fl: String, function fc: String)
{
        NSLog(msg + " at " + fc + " in " + fl)
}

public class MIError
{
        private static let ErrorDomain = "com.github.steel-wheels.MultiDataKit"

        public enum ErrorCode: Int {
                case parseError         = 1
                case fileError          = 2
        }

        public static func error(errorCode ecode: ErrorCode, message msg: String) -> NSError {
                let userinfo = [NSLocalizedDescriptionKey: msg]
                return NSError(domain: ErrorDomain, code: ecode.rawValue, userInfo: userinfo)
        }

        public static func error(errorCode ecode: ErrorCode, message msg: String, atFile fl: String, function fstr: String) -> NSError {
                let newmsg = msg + " at " + fstr + " in " + fl
                return error(errorCode: ecode, message: newmsg)
        }

        public static func parseError(message msg: String, line ln: Int) -> NSError {
                return error(errorCode: ErrorCode.parseError, message: msg + " at line \(ln)")
        }

        public static func errorToString(error err: NSError) -> String {
                let uinfo = err.userInfo
                if let msg = uinfo[NSLocalizedDescriptionKey] as? String {
                        return msg
                } else {
                        return "{Error code=\(err.code)}"
                }
        }
}
