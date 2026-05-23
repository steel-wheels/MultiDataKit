/*
 * @file UTPseudoTerminal.swift
 * @description Unit test for MIPseudoTerminal class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public func testPseudoTerminal() -> Bool
{
        NSLog("estPseudoTerminal")
        let term  = MIPseudoTerminal()
        let slave = term.slaveFile
        return MIPseudoTerminal.setTerminalSize(fileDescriptor: slave.fileDescriptor,
                                                rows: 80,
                                                cols: 25)
}

