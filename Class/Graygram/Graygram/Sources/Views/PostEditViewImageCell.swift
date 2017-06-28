
import UIKit

final class PostEditViewImageCell: UITableViewCell {
  
  // MARK: Properties
  fileprivate let photoView = UIImageView()
  
  // MARK: Initializers
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(self.photoView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Contfigure
  
  internal func configure(image: UIImage) {
    self.photoView.image = image
    setNeedsLayout()
  }
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // view의 origin은 디폴트가 (0,0) 이다.
    self.photoView.size = self.contentView.size
  }
  
  // MARK: Size
  
  class func height(width: CGFloat) -> CGFloat {
    return width              // 정사각형을 기대하므로 너비와 같은 값을 리턴
  }
}
