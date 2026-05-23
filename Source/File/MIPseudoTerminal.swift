/*
 * @file MIPseudoTerminal.swift
 * @description Define MIPseudoTerminal class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation
import Darwin

public class MIPseudoTerminal
{
        private var mMasterFile:        FileHandle      // for terminal
        private var mSlaveFile:         FileHandle      // for shell

        public var masterFile: FileHandle { get { return mMasterFile }}
        public var slaveFile:  FileHandle { get { return mSlaveFile  }}

        public init() {
                var master:     Int32 = -1
                var slave:      Int32 = -1
                guard openpty(&master, &slave, nil, nil, nil) == 0 else {
                        fatalError("Failed to open pty")
                }
                self.mMasterFile = FileHandle(fileDescriptor: master)
                self.mSlaveFile  = FileHandle(fileDescriptor: slave)

                let _ = self.mMasterFile.enableRawMode()
                let _ = self.mSlaveFile.enableRawMode()
        }

        public static func setTerminalSize(file f: FileHandle, rows: UInt16, cols: UInt16) -> MIErrorCode? {
                var ws = winsize(ws_row: rows,
                                 ws_col: cols,
                                 ws_xpixel: 0,
                                 ws_ypixel: 0)
                return MIErrorCode.encode(ioctl(f.fileDescriptor, UInt(TIOCSWINSZ), &ws))
        }
}


