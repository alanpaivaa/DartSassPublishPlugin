//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import Foundation
import Publish

/// Compiler interface that is used in the actual plugin
protocol SassCompiler {
    /// Compile Sass files into CSS files
    ///
    /// - Parameters:
    ///     - originDir: directory where the Sass files are located
    ///     - destinationDir: directory where the resulting CSS files will be written to
    ///     - context: website's publishing context
    func compileSassFiles(from originPath: Path, to destinationPath: Path, context: Context) async throws
}

final class SassCompilerImpl: SassCompiler {
    private let engine: SassCompilerEngine

    init(engine: SassCompilerEngine) {
        self.engine = engine
    }

    deinit {
        try! engine.shutdown()
    }

    func compileSassFiles(from originPath: Path, to destinationPath: Path, context: Context) async throws {
        let originDir = try context.directory(at: originPath)

        let files = originDir.files()
        guard !files.isEmpty else {
            // TODO: throw an error
            return
        }

        let destinationDir = try context.createDirectory(at: destinationPath)

        for file in files {
            let css = try await engine.compile(fileAt: file.url)
            let resultFile = try destinationDir.createFile(at: file.nameExcludingExtension + ".css")
            try resultFile.write(css, encoding: .utf8)
        }
    }
}
