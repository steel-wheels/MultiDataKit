/*
 * @file MIProcess.swift
 * @description Define MIProcess class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

#if os(OSX)

public extension Process
{
        var fileInterface: MIFileInterface? {
                get {
                        if let infile  = self.standardInput  as? FileHandle,
                           let outfile = self.standardOutput as? FileHandle,
                           let errfile = self.standardError  as? FileHandle {
                                return MIFileInterface(input: infile, output: outfile, error: errfile)
                        } else {
                                return nil
                        }
                }
                set(fileifp) {
                        if let fileif = fileifp {
                                self.standardInput      = fileif.inputFileHandle
                                self.standardOutput     = fileif.outputFileHandle
                                self.standardError      = fileif.errorFileHandle
                        }
                }
        }

        static func allocate(fileInterface fintf: MIFileInterface, commandPath path: URL, arguments args: Array<String>, environment env: MIEnvironment) -> Process {
                let newproc = Process()
                newproc.executableURL   = path
                newproc.arguments       = args
                newproc.fileInterface   = fintf
                if let path = env.currentDirectory {
                        newproc.currentDirectoryURL = path
                }
                return newproc
        }
}

#endif // os(OSX)
