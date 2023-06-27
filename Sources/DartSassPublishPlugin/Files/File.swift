//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Foundation
import Files

/// Defines an API to interact with the system's files
protocol File {
    /// The absolute URL where the file is located in the system
    var url: URL { get }

    /// The name of this file without its extension
    var nameExcludingExtension: String { get }

    /// The extension of this file
    var `extension`: String? { get }

    /// Writes a string to this file
    ///
    /// - Parameters:
    ///     - string: the value to write to the fle
    ///     - encoding: the encoding to use in the write operation
    func write(_ string: String, encoding: String.Encoding) throws
}

extension Files.File: File {}
