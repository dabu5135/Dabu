//
//  PostCardCell.swift
//  Graygram
//
//  Created by Dabu on 2017. 5. 31..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit

final class PostCardCell: UICollectionViewCell {
  
  
  // 1. 생성자
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // addSubview하는 곳
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // 2. 설정
  func configure(post: Post) {
    self.backgroundColor = .blue
  }
  
  // 3. 크기
  class func size(width: CGFloat, post: Post) -> CGSize {
    
    return CGSize(width: width, height: width)
  }
}
