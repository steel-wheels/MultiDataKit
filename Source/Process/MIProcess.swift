/*
 * @file MIProcess.swift
 * @description Define MIProcess class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation
import System

#if os(OSX)

public extension Process
{
        convenience init(environment env: MIEnvVariables) {
                self.init()
                self.set(environment: env)
        }

        func set(environment env: MIEnvVariables) {
                self.environment = env.encode()
        }

        func tryRun() -> Int32 {
                do {
                        try self.run()
                        return self.processIdentifier
                } catch {
                        if let url = self.executableURL {
                                errorLog(string: "Failed to launch: \(url.path)\n")
                        } else {
                                errorLog(string: "No executable URL\n")
                        }
                        return -1
                }
        }

        func errorLog(string str: String) {
                if let hdl = self.standardError as? FileHandle {
                        hdl.write(string: str)
                } else {
                        NSLog("[Error] \(str)")
                }
        }
}

#endif // os(OSX)
