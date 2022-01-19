import Foundation

/// Represents environment variables for the ``zet`` application.
public struct ZetEnv: Codable, Equatable {
  
  /// The username for `git`.
  public var gitUser: String
  
  /// The directory for the users`git` repositories.
  public var gitReposDirectory: String
  
  /// The default `git` branch name.
  public var gitBranch: String
  
  /// The path to the ``ZetConfig``
  public var zetConfig: String
  
  /// The zet directory.
  public var zetDirectory: String
 
  /// Creates a new ``ZetEnv`` with the default values.
  public init(
    gitUser: String = "m-housh",
    gitReposDirectory: String = "~/Repos",
    gitBranch: String = "main",
    zetConfig: String = "~/.config/zet/config.json",
    zetDirectory: String = "~/zets"
  ) {
    self.gitUser = gitUser
    self.gitReposDirectory = gitReposDirectory
    self.gitBranch = gitBranch
    self.zetConfig = zetConfig
    self.zetDirectory = zetDirectory
  }
  
  /// Custom coding keys.
  private enum CodingKeys: String, CodingKey {
    case gitUser = "GITUSER"
    case gitReposDirectory = "GITREPOS"
    case gitBranch = "GITBRANCH"
    case zetConfig = "ZETCONFIG"
    case zetDirectory = "ZETDIR"
  }
}

extension ZetEnv {
  
  /// Create a ``ZetEnv`` parsing environment variables.
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
