// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "swift-zet",
  platforms: [
    .macOS(.v10_13)
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "ShellCommand",
      dependencies: []
    ),
    .target(
      name: "ZetConfig",
      dependencies: []
    ),
    .testTarget(
      name: "ZetConfigTests",
      dependencies: ["ZetConfig"],
      resources: [
        .copy("test-config.json")
      ]
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
        "ShellCommand",
        "ZetConfig",
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
