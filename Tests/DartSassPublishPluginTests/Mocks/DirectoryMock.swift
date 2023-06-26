//
//  File.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Foundation
@testable import DartSassPublishPlugin

final class DirectoryMock: Directory {
    let allFiles: [File]

    var createFileAtPathValue: File?
    var createFileAtPathCallCount = 0
    var createFileAtPathParams = [String]()

    init(allFiles: [File]) {
        self.allFiles = allFiles
    }

    func createFile(at path: String) throws -> File {
        guard let createFileAtPathValue else {
            fatalError("createFileAtPathValue not set")
        }
        createFileAtPathCallCount += 1
        createFileAtPathParams.append(path)
        return createFileAtPathValue
    }
}
