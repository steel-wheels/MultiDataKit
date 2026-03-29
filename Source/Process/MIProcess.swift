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
        convenience init(environment env: MIEnvironment) {
                self.init()
                self.set(environment: env)
        }

        var fileInterface: MIFileInterface {
                get {
                        let infile  = self.standardInput  as? FileHandle ?? FileHandle.standardInput
                        let outfile = self.standardOutput as? FileHandle ?? FileHandle.standardOutput
                        let errfile = self.standardError  as? FileHandle ?? FileHandle.standardError
                        return MIFileInterface(input: infile, output: outfile, error: errfile)
                }
                set(fileif) {
                        self.standardInput      = fileif.inputFileHandle
                        self.standardOutput     = fileif.outputFileHandle
                        self.standardError      = fileif.errorFileHandle
                }
        }

        func set(environment env: MIEnvironment) {
                var newenv: [String:String] = [:]
                for name in env.allNames {
                        if let val = env.get(name: name as String) {
                                newenv[name as String] = val as String
                        }
                }
                self.environment = newenv
        }
}

#endif // os(OSX)
