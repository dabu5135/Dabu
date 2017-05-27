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
  
  init(title: String, isDone: Bool = false) {
    self.title = title
    self.isDone = isDone
  }
}

