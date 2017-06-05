//
//  Task.swift
//  TodoBox
//
//  Created by Dabu on 2017. 5. 24..
//  Copyright © 2017년 Dabu. All rights reserved.
//

//import Foundation  - 순수 Swift의 기능만 사용하므로 Foundation이 필요없다.

struct Task {
  
  let title: String
  let isDone: Bool
  let memo: String?
  
  init(title: String, isDone: Bool = false, memo: String? = nil) {
    self.title = title
    self.isDone = isDone
    self.memo = memo
  }
  
  // Dictionary -> Task 변환
  // Failable Initializer
  
  init?(dictionary: [String : Any]) {
    guard let title = dictionary["title"] as? String else { return nil }
    guard let isDone = dictionary["isDone"] as? Bool else { return nil }
    
    self.title = title
    self.isDone = isDone
    self.memo = dictionary["memo"] as? String
  }
  
  // Task -> Dictionary 변환
  func toDictionary() -> [String : Any] {
    var dict: [String : Any] =  [
      "title" : title,
      "isDone" : isDone,
    ]
    
    if let memo = self.memo {
      dict["memo"] = memo
    }
    
    return dict
  }
}

