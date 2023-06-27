//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import Foundation
import DartSass

/// API that a Sass compiler engine should comply with
protocol SassCompilerEngine {
    /// Compiles a Sass file (.sass, .scss) and return the CSS content as a string
    ///
    /// - Parameter fileURL: Location of the file to be compiled
    func compile(fileAt fileURL: URL) async throws -> String

    /// Performs any flushing tasks before deinitializing the engine
    func shutdown() throws
}

extension Compiler: SassCompilerEngine {
    func compile(fileAt fileURL: URL) async throws -> String {
        try await compile(fileURL: fileURL).css
    }

    func shutdown() throws {
        try syncShutdownGracefully()
    }
}
