/*
 * @file MIFileInterface.swift
 * @description Define MIFileinterface structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public class MIFileInterface
{
        public typealias ReadFunction = @Sendable (_ str: String) -> Void

        private var mInputPipe:          Pipe
        private var mOutputPipe:         Pipe
        private var mErrorPipe:          Pipe

        public init() {
                mInputPipe       = Pipe()
                mOutputPipe      = Pipe()
                mErrorPipe       = Pipe()
        }

        public var inputWriteHandle: FileHandle { get {
                return mInputPipe.fileHandleForWriting
        }}

        public var outputWriteHandle: FileHandle { get {
                return mOutputPipe.fileHandleForWriting
        }}
        public var errorWriteHandle: FileHandle { get {
                return mErrorPipe.fileHandleForWriting
        }}

        public func setInputReader(readFunctionn readf: @escaping ReadFunction) {
                set(handler: mInputPipe.fileHandleForReading, readFunction: readf)
        }

        public func setOutputReader(readFunctionn readf: @escaping ReadFunction) {
                set(handler: mOutputPipe.fileHandleForReading, readFunction: readf)
        }

        public func setErrorReader(readFunctionn readf: @escaping ReadFunction) {
                set(handler: mErrorPipe.fileHandleForReading, readFunction: readf)
        }

        private func set(handler hdl: FileHandle, readFunction readf: @escaping ReadFunction) {
                hdl.readabilityHandler = { (handler: FileHandle) in
                        let data = handler.availableData
                        if data.isEmpty {
                                handler.readabilityHandler = nil
                        } else {
                                if let str = String(data: data, encoding: .utf8){
                                        readf(str)
                                } else {
                                        NSLog("[Error] Failed to read at \(#file)")
                                }
                        }
                }
        }
}
