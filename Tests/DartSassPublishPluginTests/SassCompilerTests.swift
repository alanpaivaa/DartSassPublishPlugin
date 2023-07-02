//
//  SassCompilerTests.swift
//  
//
//  Created by Alan Paiva on 6/26/23.
//

import XCTest
@testable import DartSassPublishPlugin


final class SassCompilerTests: XCTestCase {
    private var context: ContextMock!
    private var engine: SassCompilerEngineMock!
    private var compiler: SassCompilerImpl!

    override func setUp() {
        super.setUp()

        context = ContextMock()
        engine = SassCompilerEngineMock()
        compiler = SassCompilerImpl(engine: engine)
    }

    override func tearDown() {
        compiler = nil
        engine = nil
        context = nil

        super.tearDown()
    }

    func test_compileSassFiles_whenDirectoryIsEmpty_isNoOp() async throws {
        // Arrange
        context.directoryAtPathValue = DirectoryMock(files: [])

        // Act: compile files
        do {
            try await compiler.compileSassFiles(from: "/origin/path", to: "/destination/path", context: context)
            XCTFail("Compiling should fail")
        } catch {
            guard let sassCompilerError = error as? SassCompilerError else {
                XCTFail("Not a SassCompilerError")
                return
            }
            XCTAssertEqual(sassCompilerError, .emptyDirectory)
        }

        // Assert: destination directory was not created
        XCTAssertEqual(context.directoryAtPathCallCount, 1)
        XCTAssertEqual(context.createDirectoryAtPathCallCount, 0)
    }

    func test_compileSassFiles_whenDirectoryIsNotEmpty_compilesAndCreateFiles() async throws {
        // Arrange
        let files: [FileMock] = [
            FileMock(url: URL(string: "/some/path/file1.sass")!, nameExcludingExtension: "file1", extension: "sass"),
            FileMock(url: URL(string: "/some/path/file2.scss")!, nameExcludingExtension: "file2", extension: "scss")
        ]
        context.directoryAtPathValue = DirectoryMock(files: files)

        engine.compileFileValue = "body { background-color: blue; }"

        let destinationDir = DirectoryMock(files: [])
        let destinationFile = files[0]
        destinationDir.createFileAtPathValue = destinationFile
        context.createDirectoryAtPathValue = destinationDir

        // Act: compile files
        try! await compiler.compileSassFiles(from: "/origin/path", to: "/destination/path", context: context)

        // Assert: get origin directory was called properly
        XCTAssertEqual(context.directoryAtPathCallCount, 1)

        // Assert: compile files was called properly
        XCTAssertEqual(engine.compileFileCallCount, 2)
        XCTAssertEqual(engine.compileFileParams, files.map { $0.url })

        // Assert: destination directory was created
        XCTAssertEqual(context.createDirectoryAtPathCallCount, 1)
        XCTAssertEqual(context.createDirectoryAtPathParams, ["/destination/path"])

        // Assert: destination files were created
        XCTAssertEqual(destinationDir.createFileAtPathCallCount, 2)
        XCTAssertEqual(destinationDir.createFileAtPathParams, ["file1.css", "file2.css"])

        // Assert: CSS was written to destination files
        XCTAssertEqual(destinationFile.writeCallCount, 2)
        XCTAssertEqual(destinationFile.writeParams, [engine.compileFileValue, engine.compileFileValue])
    }

    func test_compileSassFiles_whenDirectoryContainsNonSassFiles_compilesSassFilesOnly() async throws {
        // Arrange
        let files: [FileMock] = [
            FileMock(url: URL(string: "/some/path/file1.sass")!, nameExcludingExtension: "file1", extension: "sass"),
            FileMock(url: URL(string: "/some/path/file2.txt")!, nameExcludingExtension: "file2", extension: "txt"),
            FileMock(url: URL(string: "/some/path/file3")!, nameExcludingExtension: "file3", extension: nil)
        ]
        context.directoryAtPathValue = DirectoryMock(files: files)

        engine.compileFileValue = "body { background-color: blue; }"

        let destinationDir = DirectoryMock(files: [])
        let destinationFile = files[0]
        destinationDir.createFileAtPathValue = destinationFile
        context.createDirectoryAtPathValue = destinationDir

        // Act: compile files
        try! await compiler.compileSassFiles(from: "/origin/path", to: "/destination/path", context: context)

        // Assert: get origin directory was called properly
        XCTAssertEqual(context.directoryAtPathCallCount, 1)

        // Assert: compile files was called properly
        XCTAssertEqual(engine.compileFileCallCount, 1)
        XCTAssertEqual(engine.compileFileParams, [files[0].url])

        // Assert: destination directory was created
        XCTAssertEqual(context.createDirectoryAtPathCallCount, 1)
        XCTAssertEqual(context.createDirectoryAtPathParams, ["/destination/path"])

        // Assert: destination files were created
        XCTAssertEqual(destinationDir.createFileAtPathCallCount, 1)
        XCTAssertEqual(destinationDir.createFileAtPathParams, ["file1.css"])

        // Assert: CSS was written to destination files
        XCTAssertEqual(destinationFile.writeCallCount, 1)
        XCTAssertEqual(destinationFile.writeParams, [engine.compileFileValue])
    }

    func test_compileSassFiles_whenThereArePartials_compilesNonPartialSassFilesOnly() async throws {
        // Arrange
        let files: [FileMock] = [
            FileMock(url: URL(string: "/some/path/file1.scss")!, nameExcludingExtension: "file1", extension: "scss"),
            FileMock(url: URL(string: "/some/path/_file2.scss")!, nameExcludingExtension: "_file2", extension: "scss"),
            FileMock(url: URL(string: "/some/path/_file3.scss")!, nameExcludingExtension: "_file3", extension: "scss")
        ]
        context.directoryAtPathValue = DirectoryMock(files: files)

        engine.compileFileValue = "body { background-color: blue; }"

        let destinationDir = DirectoryMock(files: [])
        let destinationFile = files[0]
        destinationDir.createFileAtPathValue = destinationFile
        context.createDirectoryAtPathValue = destinationDir

        // Act: compile files
        try! await compiler.compileSassFiles(from: "/origin/path", to: "/destination/path", context: context)

        // Assert: get origin directory was called properly
        XCTAssertEqual(context.directoryAtPathCallCount, 1)

        // Assert: compile files was called properly
        XCTAssertEqual(engine.compileFileCallCount, 1)
        XCTAssertEqual(engine.compileFileParams, [files[0].url])

        // Assert: destination directory was created
        XCTAssertEqual(context.createDirectoryAtPathCallCount, 1)
        XCTAssertEqual(context.createDirectoryAtPathParams, ["/destination/path"])

        // Assert: destination files were created
        XCTAssertEqual(destinationDir.createFileAtPathCallCount, 1)
        XCTAssertEqual(destinationDir.createFileAtPathParams, ["file1.css"])

        // Assert: CSS was written to destination files
        XCTAssertEqual(destinationFile.writeCallCount, 1)
        XCTAssertEqual(destinationFile.writeParams, [engine.compileFileValue])
    }


    func test_deinit_shutsdownInternalCompiler() {
        // Act: deinitialize compiler
        compiler = nil

        // Assert: internal compiler was shutdown
        XCTAssertEqual(engine.shutdownCallCount, 1)
    }
}
