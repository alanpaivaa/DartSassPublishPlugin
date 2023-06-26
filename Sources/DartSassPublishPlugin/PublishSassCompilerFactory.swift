//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import DartSass
import Foundation

struct PublishSassCompilerFactory {
    func make() throws -> PublishSassCompiler {
        let internalCompiler = try Compiler()
        return PublishSassCompilerImpl(sassCompiler: internalCompiler)
    }
}
