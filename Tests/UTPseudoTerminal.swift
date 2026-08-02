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
        if let ecode = MIPseudoTerminal.setTerminalSize(file: slave, rows: 80, cols: 25) {
                NSLog("[Error] pseudo terminal error: \(ecode.description)")
                return false
        } else {
                return true // no error
        }
}

