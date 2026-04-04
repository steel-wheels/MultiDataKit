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
        convenience init(environment env: MIEnvironment) {
                self.init()
                self.set(environment: env)
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

        func tryRun() -> Int32 {
                do {
                        try self.run()
                        return self.processIdentifier
                } catch {
                        return -1
                }
        }
}

#endif // os(OSX)
