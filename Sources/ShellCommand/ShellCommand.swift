import Foundation

public struct ShellCommand {
  
  public var shell: Shell
  public var command: String
  
  public init(
    shell: Shell = .sh,
    command: String
  ) {
    self.shell = shell
    self.command = command
  }
  
  @discardableResult
  public func run(environment: [String: String]? = nil) throws -> Data {
    let process = Process()
    process.executableURL = shell.url
    process.arguments = ["-c", command]
    if let environment = environment {
      process.environment = environment
    }
    
    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    
    try process.run()
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    
    guard process.terminationStatus == 0 else {
      throw ShellError.commandFailed
    }
    
    return outputData
  }
  
  public enum Shell: String, CaseIterable {
    case sh, bash, zsh
    
    var url: URL {
      URL(fileURLWithPath: "/bin/\(rawValue)")
    }
  }
  
  public enum ShellError: Error {
    case commandFailed
  }
  
}
