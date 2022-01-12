import ArgumentParser
import Foundation
import ZetClient
import ZetClientLive
import ZetConfig
import ZetEnv
import ShellCommand
import ZetConfigClient

// TODO: Redo with new config clients.
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
    let configClient = ZetConfigClient.live
    guard let url = try? URL(argument: parseConfigPath()),
            let config = try? configClient.read(from: url)
    else {
      return .init()
    }
    return config
  }

  func run() throws {
    let config = try parseConfig()
    let client = try ZetClient.live(zetDirectory: config.zetURL())
    let readme = try client.createZet(title: title.joined(separator: " "))
    print("\(readme.path)")
  }
}
