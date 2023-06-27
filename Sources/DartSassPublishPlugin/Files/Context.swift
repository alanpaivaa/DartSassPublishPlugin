//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Foundation
import Publish

/// Implementers should be able to perform operations such as creating directories
protocol Context {
    /// Creates a directory. If the directory already exists, should be no-op.
    ///
    /// - Parameter path: path where the directory will be created
    func createDirectory(at path: Path) throws -> Directory

    /// Returns the reference to a directory.
    ///
    /// - Parameter path: path where the directory is located
    /// - throws an error if the directory does not exist
    func directory(at path: Path) throws -> Directory
}

extension PublishingContext: Context {
    func createDirectory(at path: Path) throws -> Directory {
        try createFolder(at: path)
    }

    func directory(at path: Path) throws -> Directory {
        try folder(at: path)
    }
}

