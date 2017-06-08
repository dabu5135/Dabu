//
//  PostCardCell.swift
//  Graygram
//
//  Created by Dabu on 2017. 5. 31..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit
import ManualLayout
import Kingfisher

final class PostCardCell: UICollectionViewCell {
  
  fileprivate enum Metric {
    // avatarView
    static let avatarViewTopPadding: CGFloat = 10.0
    static let avatarViewLeft: CGFloat = 10.0
    static let avatarViewSize: CGFloat = 30.0
    
    // username
    static let usernameLabelLeftPadding: CGFloat = 10.0
    static let usernameLabelRightPadding: CGFloat = 10.0
    
    // pictureView
    static let picktureViewTopPadding: CGFloat = 10.0
    
    // likeButton
    static let likeButtonTopPadding: CGFloat = 10.0
    static let likeButtonLeftPadding: CGFloat = 10.0
    static let likeButtonSize: CGFloat = 20.0
    
    // likeCountLabel
    static let likeCountLabelLeftPadding: CGFloat = 10.0
    static let likeCountLabelRightPadding: CGFloat = 10.0
    
    // messageLabel
    static let messageLabelTopPadding: CGFloat = 10.0
    static let messageLabelLeftPadding: CGFloat = 10.0
    static let messageLabelRightPadding: CGFloat = 10.0
  }
  
  fileprivate enum Font {
    static let usernameLabel = UIFont.boldSystemFont(ofSize: 13.0)
    static let likeCountLabel = UIFont.boldSystemFont(ofSize: 13.0)
    static let messageLabel = UIFont.systemFont(ofSize: 14.0)
  }
  
  // MARK: - Properties
  /// 사용자 프로필 이미지 뷰
  fileprivate let avatarView = UIImageView()
  
  /// 사용자 이름 레이블
  fileprivate let usernameLabel = UILabel()
  
  /// 사용자가 올린 이미지 뷰
  fileprivate let pictureView = UIImageView()
  
  fileprivate let likeButton = UIButton()
  fileprivate let likeCountLabel = UILabel()
  
  /// 사용자 메시지 레이블
  fileprivate let messageLabel = UILabel()
  
  // 1. 생성자
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // 1. 속성 초기화
    avatarView.contentMode = .scaleAspectFill
    avatarView.clipsToBounds = true
    avatarView.backgroundColor = .red
    
    usernameLabel.font = Font.usernameLabel  // 실제로는 font Medium으로 그려진다. 디자이너에게 medium으로 그려달라고 부탁해야 할 듯.
//    UIFont.systemFont(ofSize: <#T##CGFloat#>, weight: <#T##CGFloat#>) 이 메소드를 사용하면 가능할듯? iOS 8 ++
    usernameLabel.textColor = .black
    
    likeCountLabel.font = Font.likeCountLabel
    
    messageLabel.font = Font.messageLabel // graygram API에선 messageLabel이 Regular(포토샾)로 넘어온다.
    messageLabel.numberOfLines = 3
    messageLabel.backgroundColor = .blue
    
    pictureView.backgroundColor = .white
    
    // 2. addSubview하는 곳
    self.contentView.addSubview(avatarView)
    self.contentView.addSubview(usernameLabel)
    self.contentView.addSubview(pictureView)
    self.contentView.addSubview(likeButton)
    self.contentView.addSubview(likeCountLabel)
    self.contentView.addSubview(messageLabel)
    
  }
  
  // MARK: Initializer
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  // 2. 설정
  func configure(post: Post) {
    self.backgroundColor = .lightGray
    
    usernameLabel.text = post.user.username
    
    let photoURL = URL(string: "https://www.graygram.com/photos/\(post.photoID!)/640x640")!
    pictureView.kf.setImage(with: photoURL)
    likeCountLabel.text = "\(post.likeCount ?? 0)명이 좋아합니다."
    messageLabel.text = post.message
    
    setNeedsLayout()
  }

  // MARK: Size
  // 3. 크기
  class func size(width: CGFloat, post: Post) -> CGSize {
    
    var height: CGFloat = 0
    
    height += Metric.avatarViewTopPadding
    height += Metric.avatarViewSize
    
    height += Metric.picktureViewTopPadding
    height += width   // picture의 높이
    
    height += Metric.likeButtonTopPadding
    height += Metric.likeButtonSize
    
    if let message = post.message, !message.isEmpty {
      let messageLabelWidth = width - Metric.messageLabelLeftPadding - Metric.messageLabelRightPadding
      
      height += Metric.messageLabelTopPadding
      //    height += ceil(UIFont.systemFont(ofSize: 14).lineHeight)  ---- 한 줄인 경우
      //    height += message의 높이 (?)
      height += message.size(
        width: messageLabelWidth,
        font: Font.messageLabel,
        numberOfLines: 3
        ).height
    }
    
    return CGSize(width: width, height: height)
  }
  
  // MARK: Layout
  override func layoutSubviews() {
   super.layoutSubviews()
    
    let avatarViewFrame = CGRect(
      x: Metric.avatarViewLeft,
      y: Metric.avatarViewTopPadding,
      width: Metric.avatarViewSize,
      height: Metric.avatarViewSize
    )
    avatarView.frame = avatarViewFrame
    
    usernameLabel.left = avatarView.right + Metric.usernameLabelLeftPadding //    usernameLabel.x = avatarView.x + avatarViewFrame.width + 10
    usernameLabel.sizeToFit()
    usernameLabel.width = min(
      contentView.width - Metric.usernameLabelRightPadding - usernameLabel.left,
      usernameLabel.width
    )
    
    usernameLabel.centerY = avatarView.centerY //    usernameLabel.center.y = avatarView.center.y
    
    pictureView.width = contentView.width
    pictureView.height = pictureView.width
    pictureView.top = avatarView.bottom + Metric.picktureViewTopPadding
    
    likeButton.width = Metric.likeButtonSize
    likeButton.height = Metric.likeButtonSize
    likeButton.left = Metric.likeButtonLeftPadding
    likeButton.top = pictureView.bottom + Metric.likeButtonTopPadding
    
    likeCountLabel.left = likeButton.right + Metric.likeCountLabelLeftPadding
    likeCountLabel.sizeToFit()
    likeCountLabel.width = min(
      contentView.width - Metric.likeCountLabelRightPadding - likeCountLabel.left,
      likeCountLabel.width
    )
    likeCountLabel.centerY = likeButton.centerY
    
    messageLabel.top = likeButton.bottom + Metric.messageLabelTopPadding
    messageLabel.left = Metric.messageLabelLeftPadding
    
    /*
     텍스트의 줄에 맞춰 사이즈와 width를 잡는 순서
     한 줄 : sizeToFit() -> width
     여러 줄 : width -> sizeToFit()
     */
    
    messageLabel.width = contentView.width - Metric.messageLabelRightPadding - messageLabel.left
    messageLabel.sizeToFit()
  }
}
