
import UIKit

enum PhotoSize {
  case tiny
  case small
  case medium
  case large
  
  var pointSize: Int {
    switch self {
    case .tiny: return 20
    case .small: return 40
    case .medium: return 320
    case .large: return 640
    }
  }
  
  /// 실제 렌더링할 때 쓰이는 물리픽셀
  var pixelSize: Int {
    return self.pointSize * Int(UIScreen.main.scale)
  }
}

extension UIImageView {
  func setImage(photoID: String?, size: PhotoSize) {
    guard let photoID = photoID else {
      self.image = nil
      return
    }
    let urlString = "https://www.graygram.com/photos/\(photoID)/\(size.pixelSize)x\(size.pixelSize)"
    let photoURL = URL(string: urlString)!
    self.kf.setImage(with: photoURL)
  }
}
