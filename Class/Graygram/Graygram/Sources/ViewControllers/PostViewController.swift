
import UIKit

final class PostViewController: UIViewController {
  
  fileprivate let postID: Int
  
  // MARK: Initializers
  
  init(postID: Int) {
    self.postID = postID
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
}
