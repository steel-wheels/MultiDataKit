/*
 * @file MIFileManager.swift
 * @description Extend FileManager class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import Foundation

extension FileManager
{
        public var resourceDirectory: URL? { get {
                let bundle = Bundle.main
                if let url = bundle.resourceURL {
                        return url
                } else {
                        return nil
                }
        }}

        public var applicationSupportDirectory: URL { get {
                let urls = self.urls(for: .applicationSupportDirectory, in: .userDomainMask)
                if let url = urls.first {
                        return url
                } else {
                        NSLog("Can not find application support directory path")
                        let dir = NSHomeDirectory() + "/Library/Application\\ Support"
                        return URL(filePath: dir)
                }
        }}
}
