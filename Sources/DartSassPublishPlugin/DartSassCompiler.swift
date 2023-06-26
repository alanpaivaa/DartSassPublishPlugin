//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import Foundation

/// API that a Sass compiler should comply with
protocol DartSassCompiler {
    /// Compiles a Sass file (.sass, .scss) and return the CSS content as a string
    ///
    /// - Parameter fileURL: Location of the file to be compiled
    func compile(fileAt fileURL: URL) async throws -> String

    /// Performs any flushing tasks before deinitializing the compiler
    func shutdown() throws
}
