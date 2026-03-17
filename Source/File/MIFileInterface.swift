/*
 * @file MIFileInterface.swift
 * @description Define MIFileinterface structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public class MIPipeInterface
{
        private var mMasterToSlaveSPipe:        Pipe    // master:write, slace:read
        private var mSlaveToMaster2MPipe:       Pipe    // master:read,  slave:write

        public var masterToSlavePipe: Pipe { get { return mMasterToSlaveSPipe  }}
        public var slaveToMasterPipe: Pipe { get { return mSlaveToMaster2MPipe }}

        public init() {
                mMasterToSlaveSPipe      = Pipe()
                mSlaveToMaster2MPipe     = Pipe()
        }
}

public class MIFileInterface
{
        public typealias ReaderFunc = @Sendable (_ str: String) -> Void

        private var mPipeInterface:     MIPipeInterface
        private var mInputFileHandle:   FileHandle
        private var mOutputFileHandle:  FileHandle

        public init(asMaster master: MIPipeInterface) {
                mPipeInterface          = master
                mInputFileHandle        = master.slaveToMasterPipe.fileHandleForReading
                mOutputFileHandle       = master.masterToSlavePipe.fileHandleForWriting
        }

        public init(asSlave slave: MIPipeInterface) {
                mPipeInterface          = slave
                mInputFileHandle        = slave.masterToSlavePipe.fileHandleForReading
                mOutputFileHandle       = slave.slaveToMasterPipe.fileHandleForWriting
        }

        public func write(string str: String) {
                mOutputFileHandle.write(string: str)
        }

        public func setReader(reader readfunc: @escaping ReaderFunc) {
                mInputFileHandle.readabilityHandler = { (handle: FileHandle) in
                        let data = handle.availableData
                        if !data.isEmpty {
                                if let str = String(data: data, encoding: .utf8) {
                                        readfunc(str)
                                } else {
                                        NSLog("[Error] Failed to decode at \(#file)")
                                }
                        }
                }
        }
}

/*

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
*/

