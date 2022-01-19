import ArgumentParser
import Foundation
import GitClient
import ZetClient
import ZetEnv

struct DirectoryOption: ParsableArguments {
  
  @Option(name: .shortAndLong, help: "The zet directory", completion: .directory)
  var directory: URL?
  
  private func zetDirectory() throws -> URL {
    guard let directory = directory else {
      return try URL(fileURLWithPath: ZetEnv.load().zetDirectory)
    }
    return directory
  }
  
  func client() throws -> ZetClient {
    try .live(zetDirectory: zetDirectory())
  }
  
  func gitClient() throws -> GitClient {
    try .live(zetDirectory: zetDirectory())
  }
  
}
