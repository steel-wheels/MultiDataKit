/*
 * @file MIThread.swift
 * @description Define MIThread class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation
import System

public extension Thread
{
        enum State {
                case executing
                case cancelled
                case finished
        }

        var state: State { get {
                let result: State
                if self.isFinished {
                        result = .finished
                } else if self.isCancelled {
                        result = .cancelled
                } else {
                        result = .executing
                }
                return result
        }}

        static func wait(thread thd: Thread) -> State {
                var didfinished = false
                while !didfinished {
                        switch thd.state {
                        case .executing:
                                break
                        case .finished, .cancelled:
                                didfinished = true
                        }
                }
                return thd.state
        }
}
