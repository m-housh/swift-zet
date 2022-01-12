import ArgumentParser
import Foundation

extension Date {
  
  init?(isosec: String) {
    guard let date = isosecFormatter.date(from: isosec) else {
      return nil
    }
    self = date
  }
  
  var isosec: String {
    isosecFormatter.string(from: self)
  }
}

fileprivate let isosecFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()

extension URL: ExpressibleByArgument {

  /// Parses a command line string argument into a file url.
  ///
  /// - Parameters:
  ///   - argument: The command line argument
  public init?(argument: String) {
    let argument = NSString(string: argument).expandingTildeInPath
    self.init(fileURLWithPath: argument)
  }
}
