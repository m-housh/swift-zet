import XCTest
@testable import GitClient

final class GitClientTests: XCTestCase {
  
  func testGitClient2() throws {
    let client = GitClient.testing
    XCTAssertEqual(try! client.handle(.add).get(), "git add --all")
    XCTAssertEqual(try! client.handle(.commit(message: "message")).get(), "git commit -a -m \"message\"")
    XCTAssertEqual(try! client.handle(.grep(search: "search")).get(), "git grep -i --heading search")
    XCTAssertEqual(try! client.handle(.lastMessage).get(), "git log -n 1 --format=%s")
    XCTAssertEqual(try! client.handle(.pull).get(), "git pull")
    XCTAssertEqual(try! client.handle(.push).get(), "git push")
    XCTAssertEqual(try! client.handle(.status).get(), "git status")
  }
}
