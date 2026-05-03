/*
 * @file MIThread.swift
 * @description Define MIThread class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation
import System

open class MIThread: Thread
{
        public enum State {
                case executing
                case cancelled
                case finished
        }

        public var standardInput:       FileHandle
        public var standardOutput:      FileHandle
        public var standardError:       FileHandle

        public var environment:         MIEnvVariables

        public init(environment env: MIEnvVariables) {
                self.standardInput      = FileHandle.standardInput
                self.standardOutput     = FileHandle.standardOutput
                self.standardError      = FileHandle.standardError
                self.environment        = env
        }

        public var state: State { get {
                let result: State
                if self.isFinished {
                        result = .finished
                } else if self.isCancelled {
                        result = .cancelled
                } else {
                        result = .finished
                }
                return result
        }}

        static public func wait(thread thd: MIThread) -> State {
                var didfinished = false
                while !didfinished {
                        let state = thd.state
                        if state == .finished {
                                didfinished = true
                        } else {
                                Thread.sleep(forTimeInterval: 0.001)
                        }
                }
                return thd.state
        }
}

