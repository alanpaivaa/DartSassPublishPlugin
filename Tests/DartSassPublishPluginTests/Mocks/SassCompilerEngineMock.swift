//
//  SassCompilerEngineMock.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Foundation
@testable import DartSassPublishPlugin

final class SassCompilerEngineMock: SassCompilerEngine {
    var compileFileValue: String?
    var compileFileCallCount = 0
    var compileFileParams = [URL]()

    var shutdownCallCount = 0

    func compile(fileAt fileURL: URL) async throws -> String {
        guard let compileFileValue else {
            fatalError("compileFileValue not set")
        }
        compileFileCallCount += 1
        compileFileParams.append(fileURL)
        return compileFileValue
    }

    func shutdown() throws {
        shutdownCallCount += 1
    }
}
