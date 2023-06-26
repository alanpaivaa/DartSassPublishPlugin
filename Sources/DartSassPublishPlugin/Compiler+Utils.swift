//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import DartSass
import Foundation

extension Compiler: DartSassCompiler {
    func compile(fileAt fileURL: URL) async throws -> String {
        try await compile(fileURL: fileURL).css
    }

    func shutdown() throws {
        try syncShutdownGracefully()
    }
}
