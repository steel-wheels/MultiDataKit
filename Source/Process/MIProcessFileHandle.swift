/*
 * @file MIProcesshandle.swift
 * @description Define MIProcessHandle structure
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

public struct MIProcessFileHandle
{
        public var inputFileHandle:     FileHandle
        public var outputFileHandle:    FileHandle
        public var errorFilehandle:     FileHandle

        public init(input inhdl: FileHandle, output outhdl: FileHandle, error errhdl: FileHandle){
                inputFileHandle         = inhdl
                outputFileHandle        = outhdl
                errorFilehandle         = errhdl
        }
}
