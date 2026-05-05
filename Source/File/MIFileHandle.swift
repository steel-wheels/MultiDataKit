/*
 * @file MIFileHandle.swift
 * @description Define MIFileHandle structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

public extension FileHandle
{
        typealias ReaderFunc = @Sendable (_ str: String) -> Void

        func setReader(reader readfunc: @escaping ReaderFunc) {
                self.readabilityHandler = { (handle: FileHandle) in
                        let data = handle.availableData
                        if !data.isEmpty {
                                if let str = String(data: data, encoding: .utf8) {
                                        readfunc(str)
                                } else {
                                        NSLog("[Error] Failed to decode at \(#file)")
                                }
                        }
                }
        }

        func write(string src: String) {
                do {
                        if let data = src.data(using: .utf8) {
                                try self.write(contentsOf: data)
                        } else {
                                NSLog("[Error] Failed to make data at \(#file)")
                        }
                } catch {
                        NSLog("[Error] Exception occured at \(#file)")
                }
        }

        func flush() {
                do {
                        try self.synchronize()
                } catch {
                        NSLog("[Error] Failed to flush at \(#file)")
                }
        }

        /* reference: Listening to stdin in Swift at
         * https://stackoverflow.com/questions/49748507/listening-to-stdin-in-swift
         */

        // see https://stackoverflow.com/a/24335355/669586
        private static func initStruct<S>() -> S {
                let struct_pointer = UnsafeMutablePointer<S>.allocate(capacity: 1)
                let struct_memory = struct_pointer.pointee
                struct_pointer.deallocate()
                return struct_memory
        }

        func enableRawMode() -> termios {
                var raw: termios = FileHandle.initStruct()
                tcgetattr(self.fileDescriptor, &raw)

                let original = raw

                raw.c_lflag &= ~(UInt(ECHO | ICANON))
                tcsetattr(self.fileDescriptor, TCSAFLUSH, &raw);

                return original
        }

        func restoreRawMode(originalTerm: termios) {
                var term = originalTerm
                tcsetattr(self.fileDescriptor, TCSAFLUSH, &term);
        }
}
