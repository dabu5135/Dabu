//
//
////class Dog {
////  var name: String {
////    willSet {
////      print("값이 \(self.name) 에서 \(newValue)로 바뀝니다.")
////    }
////    didSet {
////      print("값이 \(oldValue) 에서 \(self.name)로 바뀌었습니다.")
////    }
////  }
////  
////  var simpleDescription: String {
////    return "강아지 \(name)"
////  }
////  
////  init(name: String) {
////    self.name = name
////  }
////  
////  deinit {
////    print("deinit!!")
////  }
////}
////
////var myDog = Dog(name: "kkk")
////myDog.name = "sdfdsf"
//
//
//// Tuple
//
////typealias CoffeeInfo = (name: String, price: Int)
////
////let coffe: CoffeeInfo = ("아메리카노",4300)
////
////let (name, price) = coffe
//
//
//
////typealias CoffeeInfo = (name: String, price: Int)
////
////let coffeeInfo: [CoffeeInfo] = [
////  ("아메리카노",4300),
////  ("라떼",4500),
////  ("핸드드립",5300),
////  ("아포카토",6300),
////  ("콜드브루",7300),
////]
////
////func find(name: String) -> CoffeeInfo? {
////  
////  return coffeeInfo.lazy
////    .filter { $0.name == name }
////    .first
////}
//
//
//// Enum
//
////enum Month: Int {
////  case jan
////  case feb
////  case mar
////
////  func displayName() -> String {
////    
////    switch self {
////    case .jan:
////      return "1"
////    case .feb:
////      return "2"
////    case .mar:
////      return "3"
////    }
////  }
////}
////
////
////let month = Month.jan
////month.rawValue
////
////
////
////enum APIResult {
////  case success(String)
////  case failure(APIError)
////}
////
////enum APIError {
////  case timeout
////  case missingParameter(String)
////  case invalidParameter(String, String)
////  
////  var message: String {
////    switch self {
////    case .timeout:
////      return ""
////    case .missingParameter(let filed):
////      return ""
////    case .invalidParameter(let filed, let message):
////      return ""
////    }
////  }
////}
////
////let error = APIError.missingParameter("sdfsdf")
////error.message
////
////
////
////
////func apiCall(_ completion: (APIResult) -> ()) {
////  
//////  completion(.success("이세준"))
////  completion(.failure(.timeout))
////}
////
////apiCall { result in
////  switch result {
////  case .success(let name):
////    print("성공 : \(name)")
////  case .failure(let error):
////    print("실패 : \(error.message)")
////  }
////}
//
//
////  Protocol
//
//protocol Messagable {
//  
//  var message: String? { get }
//}
//
//protocol Sendable: Messagable {
//  var to: String { get }
//  
//  func send()
//}
//
//struct Mail: Sendable {
//  
//  var to: String
//  var message: String?
//  func send() {
//    print("Mail Send..")
//  }
//}
//
//struct SMS: Sendable {
//  
//  var to: String
//  var message: String?
//  func send() {
//    print("SMS Send...")
//  }
//}
//
//func send(_ sendable: Sendable) {
//  sendable.send()
//}
//
//let mail = Mail(to: "mail~~", message: "sdfdsf")
//let sms = SMS(to: "SMS", message: nil)
//
//
//send(mail)
//send(sms)
//
//// Extension
//
////extension String {
////  
////  var length: Int {
////    return self.characters.count
////  }
////  
////  func reverseString() -> String {
////    return ""
////  }
////}
////
////protocol Sendable {
////  
////  func send()
////}
////
////extension Sendable {
////  
////  func send() {
////    print("sdfdsfsf")
////  }
////}
////
////
////struct Mail: Sendable {
////  
////}
////
////let mail = Mail()
////mail.send()
//



