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
    XCTAssertEqual(try! client.status(), "Status")
  }
  
  func testGitCommitUsingLastMessage() throws {
    var client = GitClient.testing
    client._lastMessage = { "The Last Message".data(using: .utf8)! }
    let commit = try client.commit(message: "last")
    XCTAssertEqual(commit, "\"The Last Message\"")
  }
  
  func testGitClient2() throws {
    let client = GitClient2.testing
    XCTAssertEqual(try! client.handle(.add).get(), "git add --all")
    XCTAssertEqual(try! client.handle(.commit(message: "message")).get(), "git commit -a -m \"message\"")
    XCTAssertEqual(try! client.handle(.grep(search: "search")).get(), "git grep -i --heading search")
    XCTAssertEqual(try! client.handle(.lastMessage).get(), "git log -n 1 --format=%s")
    XCTAssertEqual(try! client.handle(.pull).get(), "git pull")
    XCTAssertEqual(try! client.handle(.push).get(), "git push")
    XCTAssertEqual(try! client.handle(.status).get(), "git status")
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
      },
      status: {
        "Status".data(using: .utf8)!
      }
    )
  }
}
