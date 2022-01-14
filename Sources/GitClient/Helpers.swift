import Foundation
import ShellCommand

extension String {
  var quoted: String {
    "\"\(self)\""
  }
}

extension Data {
  
  func shellOutput() -> String {
    guard let output = String(data: self, encoding: .utf8) else {
      return ""
    }
    return output
  }
}

extension ShellCommand {
  
  func run(in path: URL) throws -> Data {
    FileManager.default.changeCurrentDirectoryPath(path.path)
    return try run()
  }
}
