// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "swift-zet",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "DirectoryClient",
      dependencies: []
    ),
    .testTarget(
      name: "DirectoryClientTests",
      dependencies: ["DirectoryClient"]
    ),
    .target(
      name: "GitClient",
      dependencies: [
        "ShellCommand",
        "ZetClient"
      ]
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
      ]
    ),
    .target(
      name: "ZetClientLive",
      dependencies: [
        "ZetClient",
        "GitClient"
      ]
    ),
    .testTarget(
      name: "ZetClientTests",
      dependencies: [
        "ZetClient",
        "ZetClientLive"
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
//        "GitClient",
        "ShellCommand",
        "ZetClientLive",
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
