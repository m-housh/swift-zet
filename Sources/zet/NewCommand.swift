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
    let currentDir = config.currentDir
    let zetDir = currentDir.appendingPathComponent(Date().isosec)
    let command = ShellCommand(command: "mkdir -p \(zetDir.path)")
    try command.run()
    let readme = zetDir.appendingPathComponent("README.md")
    let title = "# \(title.joined(separator: " "))\n\n"
    try title.write(toFile: readme.path, atomically: true, encoding: .utf8)
    print("\(readme.path)")
  }
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
