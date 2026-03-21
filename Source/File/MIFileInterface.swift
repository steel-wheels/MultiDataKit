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

        private var mPipeInterface:     MIPipeInterface?
        private var mInputFileHandle:   FileHandle
        private var mOutputFileHandle:  FileHandle
        private var mErrorFileHandle:   FileHandle

        public init(asMaster master: MIPipeInterface) {
                mPipeInterface          = master
                mInputFileHandle        = master.slaveToMasterPipe.fileHandleForReading
                mOutputFileHandle       = master.masterToSlavePipe.fileHandleForWriting
                mErrorFileHandle        = mOutputFileHandle
        }

        public init(asSlave slave: MIPipeInterface) {
                mPipeInterface          = slave
                mInputFileHandle        = slave.masterToSlavePipe.fileHandleForReading
                mOutputFileHandle       = slave.slaveToMasterPipe.fileHandleForWriting
                mErrorFileHandle        = mOutputFileHandle
        }

        public init(input infile: FileHandle, output outfile: FileHandle, error errfile: FileHandle) {
                mPipeInterface          = nil
                mInputFileHandle        = infile
                mOutputFileHandle       = outfile
                mErrorFileHandle        = errfile
        }

        public var inputFileHandle: FileHandle { get {
                return mInputFileHandle
        }}

        public var outputFileHandle: FileHandle { get {
                return mOutputFileHandle
        }}

        public var errorFileHandle: FileHandle { get {
                return mErrorFileHandle
        }}

        public func write(string str: String) {
                mOutputFileHandle.write(string: str)
        }

        public func error(string str: String) {
                mErrorFileHandle.write(string: str)
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


