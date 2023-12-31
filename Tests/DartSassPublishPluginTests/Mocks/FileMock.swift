//
//  FileMock.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import Foundation
@testable import DartSassPublishPlugin

final class FileMock: File {
    let url: URL
    let nameExcludingExtension: String
    let `extension`: String?

    var writeCallCount = 0
    var writeParams = [String]()

    init(url: URL, nameExcludingExtension: String, `extension`: String?) {
        self.url = url
        self.nameExcludingExtension = nameExcludingExtension
        self.`extension` = `extension`
    }

    func write(_ string: String, encoding: String.Encoding) throws {
        writeParams.append(string)
        writeCallCount += 1
    }
}
