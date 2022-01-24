import Foundation

extension Result {
  
  func print() throws {
    let val = try get()
    Swift.print("\(val)")
  }
}

extension Result where Success == URL {
  
  func path() -> Result<String, Failure> {
    map { $0.path }
  }
}

extension Result where Success == [URL] {
  
  func paths() -> Result<[String], Failure> {
    map { $0.map { $0.path } }
  }
}
