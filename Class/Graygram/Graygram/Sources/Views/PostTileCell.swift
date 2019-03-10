
import UIKit

final class PostTileCell: UICollectionViewCell {
  
  fileprivate let tileImageView = UIImageView()
  
  var didTap: (() -> Void)?
  
  // MARK: Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(self.tileImageView)
    
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(contentViewDidTap)
    )
    self.contentView.addGestureRecognizer(tapGestureRecognizer)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure
  
  func configure(post: Post) {
    self.tileImageView.setImage(photoID: post.photoID, size: .medium)
  }
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.tileImageView.size = self.contentView.size
  }
  
  // MARK: Size
  
  class func size(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: width)
  }
 
  // MARK: Selector
  // Gesture
  @objc private func contentViewDidTap() {
    self.didTap?()
  }
}
