import ArgumentParser
import Foundation
import ZetConfig
import ZetEnv
import ShellCommand

struct NewCommand: ParsableCommand {
  
  static var configuration: CommandConfiguration = .init(
    commandName: "new",
    abstract: "Creates a new zet.",
    discussion: "",
    version: "0.1",
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @Option(name: .shortAndLong, help: "The configuration to use.")
  var config: String?
  
  @Argument(help: "The title of the zet.")
  var title: [String]
  
  private func parseConfigPath() throws -> String {
    guard let config = config else {
      return try ZetEnv.load().zetConfig
    }
    return config
  }
  
  private func parseConfig() throws -> ZetConfig {
    guard let config = try? ZetConfig.load(parseConfigPath()) else {
      return ZetConfig()
    }
    return config
  }
  
  func run() throws {
    let config = try parseConfig()
    let dir = try makeIsosecDir(config: config)
    let readme = try makeReadme(in: dir, title: title.joined(separator: " "))
    print("\(readme.path)")
  }
}

extension ShellCommand {
  
  static func mkdir(path: URL) -> ShellCommand {
    .init(command: "mkdir -p \(path.path)")
  }
}

fileprivate func makeIsosecDir(config: ZetConfig) throws -> URL {
  let isosecDir = config.currentDir.appendingPathComponent(Date().isosec)
  try ShellCommand.mkdir(path: isosecDir).run()
  return isosecDir
}

fileprivate func makeReadme(in dir: URL, title: String) throws -> URL {
  let path = dir.appendingPathComponent("README.md")
  let title = "# \(title)\n\n"
  try title.write(to: path, atomically: true, encoding: .utf8)
  return path
}

extension ZetConfig {
  
  var currentDir: URL {
    switch current {
    case .public:
      return .init(fileURLWithPath: publicZets, isDirectory: true)
    case .private:
      return .init(fileURLWithPath: privateZets, isDirectory: true)
    }
  }
}
