//
//  User.swift
//  Graygram
//
//  Created by Dabu on 2017. 6. 7..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import ObjectMapper

struct User: Mappable {
  
  var id: Int!
  var username: String!
  var photoID: String?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    username <- map["username"]
    photoID <- map["photo.id"]   // 중첩된 Dictionary의 키를 . 을 통해 가져올 수 있다!!
  }
}
