//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Files
import Foundation

/// Defines an API to interact with system directories
protocol Directory {
    /// Creates a file
    ///
    /// - Parameter path: path to create the file at
    func createFile(at path: String) throws -> File

    /// The immediate files contained in this directory
    func files() -> [File]
}

extension Folder: Directory {
    func files() -> [File] {
        return files.map { $0 }
    }

    func createFile(at path: String) throws -> File {
        try createFile(at: path, contents: nil)
    }
}
