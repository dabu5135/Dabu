

import UIKit

extension UIImage {
  func grayscaled() -> UIImage? {
    
    guard let context = CGContext(
      data: nil,
      width: Int(self.size.width),
      height: Int(self.size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: CGColorSpaceCreateDeviceGray(),
      bitmapInfo: 0   
    )
    else { return nil }
    
    guard let inputCGImage = self.cgImage else { return nil }
    let imageRect = CGRect(origin: .zero, size: self.size)
    context.draw(inputCGImage, in: imageRect)
    guard let outputCGImage = context.makeImage() else { return nil }
    
    return UIImage(cgImage: outputCGImage)
  }
}
