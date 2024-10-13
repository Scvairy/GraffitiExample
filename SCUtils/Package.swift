// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SCUtils",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SCUtils",
            targets: ["SCUtils"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SCUtils"),
        .testTarget(
            name: "SCUtilsTests",
            dependencies: ["SCUtils"]
        ),
    ]
)
