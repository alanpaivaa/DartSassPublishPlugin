//
//  PublishSassCompilerTests.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import XCTest
@testable import DartSassPublishPlugin


final class PublishSassCompilerTests: XCTestCase {
    private var fileManager: CompilerFileManagerMock!
    private var internalCompiler: DartSassCompilerMock!
    private var compiler: PublishSassCompilerImpl!

    override func setUp() {
        super.setUp()

        fileManager = CompilerFileManagerMock()
        internalCompiler = DartSassCompilerMock()
        compiler = PublishSassCompilerImpl(sassCompiler: internalCompiler)
    }

    override func tearDown() {
        compiler = nil
        internalCompiler = nil
        fileManager = nil

        super.tearDown()
    }

    func test_compileSassFiles_whenDirectoryIsEmpty_isNoOp() async throws {
        // Arrange
        fileManager.directoryAtPathValue = DirectoryMock(allFiles: [])

        // Act: compile files
        try! await compiler.compileSassFiles(from: "/origin/path", to: "/destination/path", fileManager: fileManager)

        // Assert: destination directory was not created
        XCTAssertEqual(fileManager.directoryAtPathCallCount, 1)
        XCTAssertEqual(fileManager.createDirectoryAtPathCallCount, 0)
    }

    func test_compileSassFiles_whenDirectoryIsNotEmpty_compilesAndCreateFiles() async throws {
        // Arrange
        let files: [FileMock] = [
            FileMock(url: URL(string: "/some/path/file1.sass")!, nameExcludingExtension: "file1"),
            FileMock(url: URL(string: "/some/path/file2.scss")!, nameExcludingExtension: "file2")
        ]
        fileManager.directoryAtPathValue = DirectoryMock(allFiles: files)

        internalCompiler.compileFileValue = "body { background-color: blue; }"

        let destinationDir = DirectoryMock(allFiles: [])
        let destinationFile = files[0]
        destinationDir.createFileAtPathValue = destinationFile
        fileManager.createDirectoryAtPathValue = destinationDir

        // Act: compile files
        try! await compiler.compileSassFiles(from: "/origin/path", to: "/destination/path", fileManager: fileManager)

        // Assert: get origin directory was called properly
        XCTAssertEqual(fileManager.directoryAtPathCallCount, 1)

        // Assert: compile files was called properly
        XCTAssertEqual(internalCompiler.compileFileCallCount, 2)
        XCTAssertEqual(internalCompiler.compileFileParams, files.map { $0.url })

        // Assert: destination directory was created
        XCTAssertEqual(fileManager.createDirectoryAtPathCallCount, 1)
        XCTAssertEqual(fileManager.createDirectoryAtPathParams, ["/destination/path"])

        // Assert: destination files were created
        XCTAssertEqual(destinationDir.createFileAtPathCallCount, 2)
        XCTAssertEqual(destinationDir.createFileAtPathParams, ["file1.css", "file2.css"])

        // Assert: CSS was written to destination files
        XCTAssertEqual(destinationFile.writeCallCount, 2)
        XCTAssertEqual(destinationFile.writeParams, [internalCompiler.compileFileValue, internalCompiler.compileFileValue])
    }

    func test_deinit_shutsdownInternalCompiler() {
        // Act: deinitialize compiler
        compiler = nil

        // Assert: internal compiler was shutdown
        XCTAssertEqual(internalCompiler.shutdownCallCount, 1)
    }
}
