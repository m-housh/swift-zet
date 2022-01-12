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

extension URL {
  var modificationDate: Date? {
    try? resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
  }
}

extension FileManager {
  
  func directories(in path: URL) throws -> [URL] {
    try contentsOfDirectory(
      at: path,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: .skipsHiddenFiles
    )
      .filter {
        try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true
      }
  }
  
  func zetDirectory(in path: URL) throws -> URL {
    let dir = path.appendingPathComponent(Date().isosec)
    try createDirectory(
      atPath: dir.relativePath,
      withIntermediateDirectories: false,
      attributes: nil
    )
    return dir
  }
}


fileprivate let isosecFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()

