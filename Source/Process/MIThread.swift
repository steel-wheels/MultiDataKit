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
        var isRunning: Bool { get {
                return !self.isFinished
        }}

        static func wait(thread thd: Thread) -> Int32 {
                while thd.isRunning {
                        Thread.sleep(forTimeInterval: 0.0001)
                }
                if thd.isCancelled {
                        return -1
                } else {
                        return 0
                }
        }
}
