
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

extension Notification.Name {
  
  /// 좋아요를 한 경우 발생하는 노티피케이션입니다. `userInfo`에 `postID: Int`가 전달됩니다.
  static var postDidLike: Notification.Name {
//    return Notification.Name("postDidLike")
//    return Notification.Name.init("postDidLike")
    return .init("postDidLike")
  }
//  static let postDidLike: Notification.Name = Notification.Name.init("postDidLike")
  
  /// 좋아요를 취소한 경우 발생하는 노티피케이션입니다. `userInfo`에 `postID: Int`가 전달됩니다.
  static var postDidUnLike: Notification.Name {
//    return Notification.Name("postDidUnLike")
    return .init("postDidUnLike")
  }
  
  /// 새로운 `post`가 생성될 경우 발생합니다. `userInfo`에 `post: Post`가 생성됩니다.
  static let postDidCreate: Notification.Name = .init("postDidCreate")
}
