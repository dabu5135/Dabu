
import Foundation
import ObjectMapper

struct Post: Mappable {
  
  var id: Int!
  var user: User!
  var photoID: String!
  var message: String?
  var isLiked: Bool!
  var likeCount: Int!
  var createdAt: Date!
  
  init?(map: Map) {
  }
  
  // Runtime에 Json과 매핑하기 위해 mutating이 필요하다
  mutating func mapping(map: Map) {
    id <- map["id"]
    user <- map["user"]
    photoID <- map["photo.id"]
    message <- map["message"]
    isLiked <- map["is_liked"]
    likeCount <- map["like_count"]
    createdAt <- (map["created_at"], ISO8601DateTransform())
    
  }
}
