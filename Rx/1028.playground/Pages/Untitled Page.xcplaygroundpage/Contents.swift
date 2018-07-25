import Foundation

extension Double {
  
  static let someTypeProperty: String = .init("sdfdsf")
}

extension Int {
  
  var double: Int {
    return self * 2
  }
}

struct Position {
  
  var x: Float
  var y: Float
}

extension Position {
  
  func transform(withOther position: Position) -> Position {
    return Position(x: self.x + position.x,
                    y: self.y + position.y)
  }
}

let foo = Position(x: 10, y: 10)
foo.transform(withOther: Position(x: 20, y: 20))


enum API {
  
  case getList
  case getDetail
}


extension API {
  
  var host: String {
    return "https://someAPI.com"
  }
  
  var path: String {
    switch self {
    case .getList:
      return "/list"
    case .getDetail:
      return "/detail"
    }
  }
  
  var url: URL? {
    return URL(string: "\(host)\(path)")
  }
}
























