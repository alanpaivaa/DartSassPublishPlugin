// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "DartSassPublishPlugin",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "DartSassPublishPlugin",
            targets: ["DartSassPublishPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/johnfairh/swift-sass.git", from: "1.7.0"),
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),
    ],
    targets: [
        .target(
            name: "DartSassPublishPlugin",
            dependencies: [
                .product(name: "DartSass", package: "swift-sass"),
                .product(name: "Publish", package: "Publish")
            ]
        ),
        .testTarget(
            name: "DartSassPublishPluginTests",
            dependencies: ["DartSassPublishPlugin"]),
    ]
)
