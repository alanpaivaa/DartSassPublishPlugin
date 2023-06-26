//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Foundation
import Publish
@testable import DartSassPublishPlugin

final class CompilerFileManagerMock: CompilerFileManager {
    var createDirectoryAtPathValue: Directory?
    var createDirectoryAtPathCallCount = 0
    var createDirectoryAtPathParams = [Path]()

    var directoryAtPathValue: Directory?
    var directoryAtPathCallCount = 0

    func createDirectory(at path: Path) throws -> Directory {
        guard let createDirectoryAtPathValue else {
            fatalError("createDirectoryAtPathValue")
        }
        createDirectoryAtPathCallCount += 1
        createDirectoryAtPathParams.append(path)
        return createDirectoryAtPathValue
    }

    func directory(at path: Path) throws -> Directory {
        guard let directoryAtPathValue else {
            fatalError("directoryAtPathValue not set")
        }
        directoryAtPathCallCount += 1
        return directoryAtPathValue
    }
}
