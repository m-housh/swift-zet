import XCTest
@testable import GitClient

final class GitClientTests: XCTestCase {
  
  func testGitClientInterface() {
    let client = GitClient.testing
    XCTAssertEqual(try! client.add(), "Add")
    XCTAssertEqual(try! client.commit(message: "message"), "\"message\"")
    XCTAssertEqual(try! client.grep(search: "something"), "something")
    XCTAssertEqual(try! client.lastMessage(), "Last")
    XCTAssertEqual(try! client.commit(message: nil), "\"Last\"")
    XCTAssertEqual(try! client.pull(), "Pull")
    XCTAssertEqual(try! client.push(), "Push")
  }
  
}

extension GitClient {
  
  static var testing: Self {
    .init(
      add: {
        "Add".data(using: .utf8)!
      },
      commit: { message in
        message.data(using: .utf8)!
      },
      grep: { search in
        search.data(using: .utf8)!
      },
      lastMessage: {
        "Last".data(using: .utf8)!
      },
      pull: {
        "Pull".data(using: .utf8)!
      },
      push: {
        "Push".data(using: .utf8)!
      }
    )
  }
}
