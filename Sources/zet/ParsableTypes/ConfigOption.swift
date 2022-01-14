import ArgumentParser
import Foundation
import GitClient
import ZetClientLive
import ZetConfigClient
import ZetEnv

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
  
  func gitClient() throws -> GitClient {
    try .live(zetDirectory: client().zetDirectory())
  }
}
