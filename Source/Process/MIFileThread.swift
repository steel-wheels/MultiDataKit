/*
 * @file MIFileThread.swift
 * @description Define MIFileThread class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

open class MIFileThread: Thread
{
        public var standardInput:       FileHandle
        public var standardOutput:      FileHandle
        public var standardError:       FileHandle

        public var exitCode:            Int

        public override init() {
                self.standardInput  = FileHandle.standardInput
                self.standardOutput = FileHandle.standardOutput
                self.standardError  = FileHandle.standardError
                self.exitCode       = 0
        }

        public func print(string str: String) {
                self.standardOutput.write(string: str)
        }

        public func error(string str: String){
                self.standardError.write(string: str)
        }
}
