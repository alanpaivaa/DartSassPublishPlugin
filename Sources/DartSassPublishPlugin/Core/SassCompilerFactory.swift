//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/25/23.
//

import DartSass
import Foundation

struct SassCompilerFactory {
    func make() throws -> SassCompiler {
        let engine = try Compiler()
        return SassCompilerImpl(engine: engine)
    }
}
