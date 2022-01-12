import ArgumentParser
import Foundation
import ZetManager

@main
struct ZetCommand: ParsableCommand {
  static var configuration: CommandConfiguration = .init(
    commandName: "zet",
    abstract: "The zet command",
    discussion: "",
    version: "0.1",
    shouldDisplay: true,
    subcommands: [FileManagerTestCommand.self, ConfigCommand.self, NewCommand.self],
    defaultSubcommand: nil,
    helpNames: nil
  )
}

struct FileManagerTestCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "file",
    abstract: "A test command",
    discussion: "",
    version: "0.1",
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  func run() throws {
    let hcpn = "/Volumes/Bucket/Repos/github.com/hhe-dev/hcp-notes"
    let manager = ZetManager(URL(string: hcpn)!)
    let items = try manager.directories()
      .sorted { lhs, rhs in
        guard let lhsDate = try lhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
              let rhsDate = try rhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
        else { return false }
        return lhsDate > rhsDate
      }
    for i in items {
      print("\(i)")
    }
    print()
    print(try manager.lastModifiedDirectory()!)
    
//    print(try manager.makeZetDirectory())
  }
}
