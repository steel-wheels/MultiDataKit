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

        public func resourceDirectory(forClass fclass: AnyClass?) -> URL? {
                let bundle: Bundle
                if let cls = fclass {
                        bundle = Bundle(for: cls)
                } else {
                        bundle = Bundle.main
                }
                if let url = bundle.resourceURL {
                        return url
                } else {
                        return nil
                }
        }

        public var cacheDirectory: URL? { get {
                let urls = self.urls(for: .cachesDirectory, in: .userDomainMask)
                if let url = urls.first {
                        return url
                } else {
                        NSLog("[Error] Can not find cache directory path")
                        return nil
                }
        }}

        public func copyFile(from fromurl: URL, to tourl: URL) -> NSError? {
                do {
                        /* remmove destinarion file */
                        if self.fileExists(atPath: tourl.path) {
                                try self.removeItem(at: tourl)
                        }
                        /* copy directories */
                        try self.copyItem(at: fromurl, to: tourl)
                        return nil
                } catch {
                        let err = MIError.error(errorCode: .fileError, message: "Failed to copy file from \(fromurl.absoluteString) to \(tourl.absoluteString)")
                        return err
                }
        }

        public func replaceFile(target tfile: URL, by bfile: URL) -> NSError? {
                do {
                        try self.replaceItem(at: tfile, withItemAt: bfile, backupItemName: nil, resultingItemURL: nil)
                        return nil
                } catch {
                        let err = MIError.error(errorCode: .fileError, message: "Failed to replace file  \(tfile.absoluteString) to \(bfile.absoluteString)")
                        return err
                }
        }

        private func URLofCacheFile(source src: URL) -> Result<URL, NSError> {
                let filename = src.lastPathComponent
                guard let appdir = cacheDirectory else {
                        let err = MIError.error(errorCode: .fileError, message: "cache directory is not found", atFile: #file, function: #function)
                        return .failure(err)
                }
                return .success(appdir.appending(path: filename))
        }

        public func createDirectory(at dir: URL) -> NSError? {
                do {
                        try self.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
                        return nil
                } catch {
                        let err = MIError.error(errorCode: .fileError, message: "Failed to create \(dir.path) directory", atFile: #file, function: #function)
                        return err
                }
        }

        public func createCacheFile(source src: URL) -> Result<URL, NSError> {
                let cachefile: URL
                switch URLofCacheFile(source: src) {
                case .success(let url):
                        cachefile = url
                case .failure(let err):
                        return .failure(err)
                }

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

        public func cleanCacheFile(source src: URL) -> NSError? {
                let cachefile: URL
                switch URLofCacheFile(source: src) {
                case .success(let url):
                        cachefile = url
                case .failure(let err):
                        return err
                }
                if self.fileExists(atPath: cachefile.path) {
                        return self.replaceFile(target: cachefile, by: src)
                } else {
                        return self.copyFile(from: src, to: cachefile)
                }
        }
}
