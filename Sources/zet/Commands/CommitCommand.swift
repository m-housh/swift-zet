import ArgumentParser
import Foundation
import GitClient

// TODO: Fix so that only one command is needed, message can be `nil`, `last`, or `new message`.
struct CommitCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "commit",
    abstract: "Commit the zets to git.",
    discussion: "If you would like to use the last commit message then you can run `zet commit last` command.",
    version: VERSION,
    shouldDisplay: true,
    subcommands: [LastCommand.self, MessageCommand.self],
    defaultSubcommand: MessageCommand.self,
    helpNames: nil
  )
}

extension CommitCommand {
  
  // MARK: Message
  struct MessageCommand: ParsableCommand {
    
    static let configuration: CommandConfiguration = .init(
      commandName: "message",
      abstract: "Commit the zets to git with the given message.",
      discussion: "",
      version: VERSION,
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var directoryOption: DirectoryOption
    
    @Flag(inversion: .prefixedNo, help: "Enable or disable pushing to remote")
    var push: Bool = true
    
    @Argument var message: [String]
    
    func run() throws {
      guard message.count > 0 else {
        fatalError("Must provide a commit message or use `last`")
      }
      let gitClient = try directoryOption.gitClient()
      let commit = try gitClient.commit(message: message.joined(separator: " "))
      if push {
        try gitClient.push()
      }
      print(commit)
    }
  }
}

extension CommitCommand {
  
  // MARK: Last
  struct LastCommand: ParsableCommand {
    
    static let configuration: CommandConfiguration = .init(
      commandName: "last",
      abstract: "Commit the zets to git, using the last commit message.",
      discussion: "",
      version: VERSION,
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
//    @OptionGroup var configOption: ConfigOption
    @OptionGroup var directoryOption: DirectoryOption
    
    func run() throws {
      let gitClient = try directoryOption.gitClient()
      let commit = try gitClient.commit(message: nil)
      print(commit)
    }
  }
}
