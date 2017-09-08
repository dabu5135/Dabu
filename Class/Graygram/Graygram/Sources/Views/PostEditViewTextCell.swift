import UIKit

final class PostEditViewTextCell: UITableViewCell {
  
  fileprivate enum Font {
    static let textView = UIFont.systemFont(ofSize: 14)
  }
  
  // MARK: Properties
  
  fileprivate let textView = UITextView()
  
  var textDidChange: ((String?) -> Void)?
  
  // 1. 생성자 -> 2. 설정 -> 3. 레이아웃 -> 4. 크기 순으로 구현 ~~~
  
  // MARK: Initailizers
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.textView.font = Font.textView
    self.textView.delegate = self
    self.textView.isScrollEnabled = false
    self.contentView.addSubview(self.textView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure
  
  func configure(text: String?) {
    self.textView.text = text
    setNeedsLayout()
  }
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.textView.size = self.contentView.size
  }
  
  // MARK: Size
  
  class func height(width: CGFloat, text: String?) -> CGFloat {
    let margin = CGFloat(10)
    let minimumHeight = ceil(Font.textView.lineHeight) * 3
    guard let text = text else { return minimumHeight + margin * 2 }
    return max(
      text.size(width: width, font: Font.textView).height,
      minimumHeight
      ) + margin * 2
  }
}

// MARK: - TextView Delegate

extension PostEditViewTextCell: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    self.textDidChange?(textView.text)
  }
}
