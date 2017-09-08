
protocol APIServiceType {}


extension APIServiceType {
  
  /// path를 가지고 urlString을 만들어서 반환합니다.
  ///
  /// - Parameter path: API path (e.g. /me)
  /// - Returns: 완성된 urlString
  static func url(_ path: String) -> String {
    return "https://api.graygram.com" + path
  }
}
