import ArgumentParser
import Foundation
import ShellCommand
import ZetConfig
import ZetEnv

struct ConfigCommand: ParsableCommand {
  
  static var configuration: CommandConfiguration = .init(
    commandName: "config",
    abstract: "Zet configuration commands",
    discussion: "",
    version: "0.1",
    shouldDisplay: true,
    subcommands: [Edit.self, Print.self, Write.self],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  struct ConfigPath: ExpressibleByArgument {
    var filePath: String
    init?(argument: String) {
      self.filePath = argument
    }
  }
  
  struct ConfigOptions: ParsableArguments {
    
    @Argument(help: "Optional configuration path.")
    var configPath: ConfigPath?
    
    func parse() throws -> ConfigPath {
      guard let configPath = configPath else {
        return try .init(argument: ZetEnv.load().zetConfig)!
      }
      return configPath
    }
  }
  
  struct Write: ParsableCommand {
    
    static var configuration: CommandConfiguration = .init(
      commandName: "write",
      abstract: "Write the default configuration.",
      discussion: "",
      version: "0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var options: ConfigOptions
    
    func run() throws {
      let path = try options.parse().filePath
      try ZetConfig().write(to: path)
      print("Wrote configuration file to: '\(path)'")
    }
  }
  
  struct Print: ParsableCommand {
    
    static var configuration: CommandConfiguration = .init(
      commandName: "print",
      abstract: "Print the configuration.",
      discussion: "",
      version: "0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var options: ConfigOptions
    
    func run() throws {
      let path = try options.parse().filePath
      let contents = try String.init(contentsOfFile: path)
      print("\(contents)")
    }
  }
  
  // Doesn't work as expected bc shell command is a sub-process, is my guess.
  struct Edit: ParsableCommand {
    
    static var configuration: CommandConfiguration = .init(
      commandName: "edit",
      abstract: "Edit the configuration.",
      discussion: "",
      version: "0.1",
      shouldDisplay: true,
      subcommands: [],
      defaultSubcommand: nil,
      helpNames: nil
    )
    
    @OptionGroup var options: ConfigOptions
    
    func run() throws {
      let path = try options.parse().filePath
      let command = ShellCommand.init(command: "exec vi \(path)")
      try command.run()
      print("Done.")
    }
  }
}
