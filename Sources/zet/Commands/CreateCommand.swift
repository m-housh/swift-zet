import ArgumentParser
import Foundation
import GitClient
import ZetClient
import ZetEnv
import ShellCommand

struct CreateCommand: ParsableCommand {
  
  static var configuration: CommandConfiguration = .init(
    commandName: "create",
    abstract: "Creates a new zet.",
    discussion: "",
    version: VERSION ?? "0.0.0",
    shouldDisplay: true,
    subcommands: [AssetsCommand.self, ZetCommand.self],
    defaultSubcommand: ZetCommand.self, // Hmm, do we want it to always create a new zet??
    helpNames: nil
  )
 }

extension CreateCommand {
  // MARK: Zet
  struct ZetCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration = .init(
      commandName: "zet",
      abstract: "Creates a new zet.",
      discussion: "",
      version: VERSION ?? "0.0.0",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var directoryOption: DirectoryOption
    
    @Argument(help: "The title of the zet.")
    var title: [String]
   
    func run() throws {
      try directoryOption.zetClient()
        .createReadme(titled: title.joined(separator: " "))
        .commit()
        .path()
        .print()
    }
  }
}

extension CreateCommand {
  
  // MARK: Assets
  // TODO: need to have this add / commit assets to git.
  struct AssetsCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
      commandName: "assets",
      abstract: "Create assets directory",
      discussion: "",
      version: VERSION ?? "0.0.0",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var directoryOption: DirectoryOption
    
    @Argument(help: "The path to create the assets directory in.")
    var path: URL?
    
    func run() throws {
      try directoryOption.zetClient()
        .parseAssetsPath(path: path)
        .createAssets()
        .path()
        .print()
    }
  }
}

extension Result where Success == ZetClient, Failure == Error {
  
  func parseAssetsPath(path: URL?) -> Result<(ZetClient, URL), Error> {
    flatMap { client in
      guard let path = path else {
        return .init {
          let last = try client.lastModified(.directory).get()
          return (client, last)
        }
      }
      return .success((client, path))
    }
  }
  
  func createReadme(titled title: String) -> Result<(ZetClient, URL, String), Error> {
    flatMap { client in
      client.create(.zet(titled: title))
        .map { url in (client, url, title) }
    }
  }
}

extension Result where Success == (ZetClient, URL), Failure == Error {
  
  func createAssets() -> Result<URL, Error> {
    flatMap { client, assetPath in
      client.create(.assets(parent: assetPath))
        .flatMap { url in
          client.git(.add)
            .map { _ in url }
        }
    }
  }
}

extension Result where Success == (ZetClient, URL, String), Failure == Error {
  private func addToGit() -> Self {
    flatMap { client, url, title in
      client.git(.add)
        .flatMap { _ in self }
    }
  }
  
  func commit() -> Result<URL, Error> {
    addToGit()
      .flatMap { client, url, title in
        client.git(.commit(message: title))
          .map { _ in url }
      }
  }
}
