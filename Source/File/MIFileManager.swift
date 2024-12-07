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

        public var cacheDirectory: URL? { get {
                let urls = self.urls(for: .cachesDirectory, in: .userDomainMask)
                if let url = urls.first {
                        return url
                } else {
                        NSLog("[Error] Can not find cache directory path")
                        return nil
                }
        }}

        public func copyFile(from furl: URL, to turl: URL) -> NSError? {
                do {
                        try self.copyItem(at: furl, to: turl)
                        return nil
                } catch {
                        let err = MIError.error(errorCode: .fileError, message: "Failed to copy file from \(furl.absoluteString) to \(turl.absoluteString)")
                        return err
                }
        }

        public func createCacheFile(source src: URL) -> Result<URL, NSError> {
                let filename = src.lastPathComponent
                guard let appdir = cacheDirectory else {
                        let err = MIError.error(errorCode: .fileError, message: "cache directory is not found", atFile: #file, function: #function)
                        return .failure(err)
                }
                let cachefile = appdir.appending(path: filename)
                if !self.fileExists(atPath: cachefile.path) {
                        NSLog("file is NOT exist: \(cachefile.absoluteString)")
                        if let err = self.copyFile(from: src, to: cachefile) {
                                return .failure(err)
                        }
                        NSLog("success to copy file")
                } else {
                        NSLog("file is exist: \(cachefile.absoluteString)")
                }
                return .success(cachefile)
        }
}
