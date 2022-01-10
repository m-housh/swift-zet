import XCTest
@testable import ZetEnv

class ZetEnvTests: XCTestCase {
  
  func testLoadingEnv() throws {
    let env = try ZetEnv.load()
    XCTAssertEqual(env.gitBranch, "main")
    XCTAssertEqual(env.gitReposDirectory, "~/Repos")
    XCTAssertEqual(env.gitUser, "m-housh")
  }
  
  func testLoadingFromEnvironmentOverwritesDefaults() throws {
    let envDict = ["GITBRANCH": "master", "GITREPOS": "/custom", "GITUSER": "test"]
    let env = try ZetEnv.load(environment: envDict)
    XCTAssertEqual(env.gitBranch, "master")
    XCTAssertEqual(env.gitReposDirectory, "/custom")
    XCTAssertEqual(env.gitUser, "test")
  }
}
