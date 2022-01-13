import ArgumentParser
import Foundation
import ZetClient
import ZetClientLive
import ZetConfig
import ZetEnv
import ShellCommand
import ZetConfigClient

struct CreateCommand: ParsableCommand {
  
  static var configuration: CommandConfiguration = .init(
    commandName: "create",
    abstract: "Creates a new zet.",
    discussion: "",
    version: "0.1",
    shouldDisplay: true,
    subcommands: [AssetsCommand.self, ZetCommand.self],
    defaultSubcommand: ZetCommand.self, // Hmm, do we want it to always create a new zet??
    helpNames: nil
  )
  
  struct ConfigOption: ParsableArguments {
    
    @Option(name: [.short, .customLong("config")], help: "The configuration to use.")
    var configPath: String?
    
    private func parseConfigPath() throws -> String {
      guard let config = configPath else {
        return try ZetEnv.load().zetConfig
      }
      return config
    }
   
    private func config() throws -> ZetConfig {
      let configClient = ZetConfigClient.live
      guard let url = try? URL(argument: parseConfigPath()),
            let config = try? configClient.read(from: url)
      else {
        return .init()
      }
      return config
    }
    
    func client() throws -> ZetClient {
      try .live(zetDirectory: config().zetURL())
    }
  }
 }

extension CreateCommand {
  // MARK: Zet
  struct ZetCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration = .init(
      commandName: "zet",
      abstract: "Creates a new zet.",
      discussion: "",
      version: "0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var configOption: ConfigOption
    
    @Argument(help: "The title of the zet.")
    var title: [String]
   
    func run() throws {
      let readme = try configOption
        .client()
        .createZet(title: title.joined(separator: " "))
      print("\(readme.path)")
    }
  }
  
  
}
extension CreateCommand {
  
  // MARK: Assets
  struct AssetsCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
      commandName: "assets",
      abstract: "Create assets directory",
      discussion: "",
      version: "0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var configOption: ConfigOption
    
    @Argument(help: "The path to create the assets directory in.")
    var path: URL?
    
    func run() throws {
      let client = try configOption.client()
      var assets: URL?
      
      if let path = path {
        assets = try client.makeAssets(in: path)
      } else if let last = try client.lastModifiedDirectory() {
        assets = try client.makeAssets(in: last)
      }
      
      guard let assets = assets else {
        fatalError("Invalid path")
      }
      
      print("\(assets.path)")
    }
  }
}
