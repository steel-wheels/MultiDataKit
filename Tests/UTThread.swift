/*
 * @file UTThread.swift
 * @description Unit test for MIThread class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public class UTThread: MIThread
{
        public override func main() {
                self.standardOutput.write(string: "Message from Thread\n")
        }
}

public func testThread() -> Bool
{
        let env = MIEnvVariables(parent: nil)
        let thread0 = UTThread(environment: env)
        thread0.start()
        let result = MIThread.wait(thread: thread0)
        return result == .finished
}

