
import Foundation
import ObjectMapper

struct Post: Mappable {
  
  var id: Int!
  var message: String?
  var createdAt: Date!
  
  init?(map: Map) {
    
    
  }
  
  // Runtime에 Json과 매핑하기 위해 mutating이 필요하다
  mutating func mapping(map: Map) {
    id <- map["id"]
    message <- map["message"]
    createdAt <- (map["created_at"], ISO8601DateTransform())  // ISO-8601 ex. "2017-02-07T09:23:13+0000"
  }
}
