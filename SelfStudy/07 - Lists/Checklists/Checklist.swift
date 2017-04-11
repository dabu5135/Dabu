//
//  Checklist.swift
//  Checklists
//
//  Created by Matthijs on 07/07/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import UIKit

class Checklist: NSObject {
  var name = ""
  
  init(name: String) {
    self.name = name
    super.init()
  }
}
