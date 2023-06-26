//
//  Created by Alan Paiva on 1/9/22.
//

import Foundation
import Publish
import DartSass

public extension Plugin {
    /// Compile Sass files into CSS files
    ///
    /// - Parameters:
    ///     - originDir: directory where the Sass files are located
    ///     - destinationDir: directory where the resulting CSS files will be written to
    static func compileSass(from originDir: Path, to destinationDir: Path) -> Self {
        Plugin(name: "DartSass") { context in
            let factory = PublishSassCompilerFactory()
            let compiler = try factory.make()
            try await compiler.compileSassFiles(
                from: originDir,
                to: destinationDir,
                fileManager: context
            )
        }
    }
}
