import Foundation

public struct ZetEnv: Codable, Equatable {
  
  public var gitUser: String
  public var gitReposDirectory: String
  public var gitBranch: String
  public var zetConfig: String
  
  init(
    gitUser: String = "m-housh",
    gitReposDirectory: String = "~/Repos",
    gitBranch: String = "main",
    zetConfig: String = "~/.config/zet/config.json"
  ) {
    self.gitUser = gitUser
    self.gitReposDirectory = gitReposDirectory
    self.gitBranch = gitBranch
    self.zetConfig = zetConfig
  }
  
  private enum CodingKeys: String, CodingKey {
    case gitUser = "GITUSER"
    case gitReposDirectory = "GITREPOS"
    case gitBranch = "GITBRANCH"
    case zetConfig = "ZET_CONFIG"
  }
}

extension ZetEnv {
  
  public static func load(
    environment: [String: String] = ProcessInfo.processInfo.environment,
    encoder: JSONEncoder = .init(),
    decoder: JSONDecoder = .init()
  ) throws -> ZetEnv {
    
    let defaultZetEnv = ZetEnv()
    let defaultZetEnvData = try encoder.encode(defaultZetEnv)
    let defaultZetEnvDict = try decoder.decode([String: String].self, from: defaultZetEnvData)
    let zetEnvDict = defaultZetEnvDict.merging(environment, uniquingKeysWith: { $1 })
    
    let data = try encoder.encode(zetEnvDict)
    let zetEnv = try decoder.decode(ZetEnv.self, from: data)
    return zetEnv
  }
}
