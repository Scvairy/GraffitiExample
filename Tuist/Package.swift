// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
  name: "GraffitiExample",
  platforms: [
    .iOS(.v18),
  ],
  products: [
    .executable(name: "GraffitiApp", targets: ["GraffitiApp"]),
  ],
  dependencies: [
    .package(name: "SCNetwork", path: "../SCNetwork"),
  ],
  targets: [
    .executableTarget(
      name: "GraffitiApp",
      dependencies: [
        "SCNetwork",
      ],
      path: "Sources/GraffitiApp",
      resources: [
        .process("Resources"),
      ]
    ),
  ]
)
