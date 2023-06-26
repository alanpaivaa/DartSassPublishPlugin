//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import Foundation
import Publish

/// Compiler interface that is used in the actual plugin
protocol PublishSassCompiler {
    /// Compile Sass files into CSS files
    ///
    /// - Parameters:
    ///     - originDir: directory where the Sass files are located
    ///     - destinationDir: directory where the resulting CSS files will be written to
    ///     - context: website's publishing context
    func compileSassFiles(from originPath: Path, to destinationPath: Path, fileManager: CompilerFileManager) async throws
}

final class PublishSassCompilerImpl: PublishSassCompiler {
    private let sassCompiler: DartSassCompiler

    init(sassCompiler: DartSassCompiler) {
        self.sassCompiler = sassCompiler
    }

    deinit {
        try! sassCompiler.shutdown()
    }

    func compileSassFiles(from originPath: Path, to destinationPath: Path, fileManager: CompilerFileManager) async throws {
        let originDir = try fileManager.directory(at: originPath)

        let files = originDir.allFiles
        guard !files.isEmpty else {
            // TODO: throw an error
            return
        }

        let destinationDir = try fileManager.createDirectory(at: destinationPath)

        for file in files {
            let css = try await sassCompiler.compile(fileAt: file.url)
            let resultFile = try destinationDir.createFile(at: file.nameExcludingExtension + ".css")
            try resultFile.write(css, encoding: .utf8)
        }
    }
}
