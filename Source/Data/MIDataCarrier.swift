/*
 * @file MIDataCarrier.swift
 * @description Define MIDataCarrier class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

public class MIDataCarrier<DataType>
{
        private var mObject:    DataType?

        public init() {
                mObject = nil
        }

        public func send(_ obj: DataType) {
                mObject = obj
        }

        public func receive() -> DataType? {
                let result = mObject
                mObject = nil
                return result
        }
}
