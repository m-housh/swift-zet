import Foundation

/// Represents a shell command that can be executed as a sub-process.
public struct ShellCommand {
  
  /// The executable shell to use.
  public var shell: Shell
  
  /// The shell command to run.
  public var command: String
  
  /// Create a new a ``ShellCommand``.
  ///
  /// - Parameters:
  ///   - shell: The executable shell to use.
  ///   - command: The shell command to run.
  public init(
    shell: Shell = .sh,
    command: String
  ) {
    self.shell = shell
    self.command = command
  }
  
  /// Run the shell command as a sub-process.
  ///
  /// - Parameters:
  ///   - environment: Optional environment variables for the process.
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
  
  /// Represents the shell executable paths that can be used in ``ShellCommand``'s.
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
