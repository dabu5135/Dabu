import UIKit

final class CollectionActivityIndicatorView: UICollectionReusableView {
  
  fileprivate let activityIndicatorView = UIActivityIndicatorView(
    activityIndicatorStyle: .gray
  )
  
  // MARK: Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    activityIndicatorView.startAnimating()
    self.addSubview(activityIndicatorView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    activityIndicatorView.centerX = self.width / 2.0
    activityIndicatorView.centerY = self.height / 2.0
  }
}
