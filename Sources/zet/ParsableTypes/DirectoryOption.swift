import ArgumentParser
import Foundation
import GitClient
import ZetClient
import ZetEnv

struct DirectoryOption: ParsableArguments {
  
  @Option(name: .shortAndLong, help: "The zet directory", completion: .directory)
  var directory: URL?
  
  private func zetDirectory() -> Result<URL, Error> {
    .init {
      guard let directory = directory else {
        return try URL(fileURLWithPath: ZetEnv.load().zetDirectory)
      }
      return directory
    }
  }
  
//  func client() throws -> ZetClient2 {
//    try .live(zetDirectory: zetDirectory())
//  }
  
  func zetClient() -> Result<ZetClient, Error> {
    zetDirectory().map { .live(zetDirectory: $0) }
//    .init {
//      try .live(zetDirectory: zetDirectory())
//    }
  }
  
}
