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
    func compileSassFiles<S>(from originDir: Path, to destinationDir: Path, context: PublishingContext<S>) async throws
}

struct PublishSassCompilerImpl: PublishSassCompiler {
    private let sassCompiler: DartSassCompiler

    init(sassCompiler: DartSassCompiler) {
        self.sassCompiler = sassCompiler
    }

    func compileSassFiles<S>(from originDir: Path, to destinationDir: Path, context: PublishingContext<S>) async throws {
        let originFolder = try context.folder(at: originDir)
        let destinationFolder = try context.createFolder(at: destinationDir)

        for file in originFolder.files {
            let css = try await sassCompiler.compile(fileAt: file.url)
            let resultFile = try destinationFolder.createFile(at: file.nameExcludingExtension + ".css")
            try resultFile.write(css)
        }

        try sassCompiler.shutdown()
    }
}
