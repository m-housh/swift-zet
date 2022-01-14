// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "swift-zet",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
//    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git", from: "0.2.0")
  ],
  targets: [
    .target(
      name: "GitClient",
      dependencies: ["ShellCommand"]
    ),
    .testTarget(
      name: "GitClientTests",
      dependencies: ["GitClient"]
    ),
    .target(
      name: "ShellCommand",
      dependencies: []
    ),
    .target(
      name: "ZetClient",
      dependencies: [
//        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")
      ]
    ),
    .target(
      name: "ZetClientLive",
      dependencies: ["ZetClient"]
    ),
    .testTarget(
      name: "ZetClientTests",
      dependencies: [
        "ZetClient",
        "ZetClientLive"
//        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")
      ]
    ),
    .target(
      name: "ZetConfig",
      dependencies: []
    ),
    .target(
      name: "ZetConfigClient",
      dependencies: ["ZetConfig"]
    ),
    .testTarget(
      name: "ZetConfigClientTests",
      dependencies: ["ZetConfigClient"]
    ),
    .target(
      name: "ZetEnv",
      dependencies: []
    ),
    .testTarget(
      name: "ZetEnvTests",
      dependencies: ["ZetEnv"],
      resources: nil
    ),
    .executableTarget(
      name: "zet",
      dependencies: [
        "GitClient",
        "ShellCommand",
        "ZetClientLive",
        "ZetConfig",
        "ZetConfigClient",
        "ZetEnv",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),
    .testTarget(
      name: "swift-zetTests",
      dependencies: ["zet"]
    ),
  ]
)
