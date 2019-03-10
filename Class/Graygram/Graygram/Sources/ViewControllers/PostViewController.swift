
import UIKit

final class PostViewController: UIViewController {
  
  private let postID: Int
  private var post: Post?
  
  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  
  // MARK: Initializers
  
  init(postID: Int) {
    self.postID = postID
    super.init(nibName: nil, bundle: nil)
    
    self.collectionView.backgroundColor = .white
    self.collectionView.alwaysBounceVertical = true
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.register(PostCardCell.self, forCellWithReuseIdentifier: "postCardCell")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(self.collectionView)
    
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.fetchPost()
  }
  
  // MARK: API Call
  
  private func fetchPost() {
    PostService.post(id: self.postID) { [weak self] response in
      guard let `self` = self else { return }
      switch response.result {
      case .success(let post):
        self.post = post
        self.collectionView.reloadData()
      case .failure(let error):
        print("Post 로드 실패 \(error)")
      }
    }
  }
  
}

// MARK: UICollectionView DataSource

extension PostViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.post == nil ? 0 : 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "postCardCell",
      for: indexPath) as! PostCardCell
    if let post = self.post {
      cell.configure(post: post, isMessageTrimmed: false)
    }
    return cell
  }
}

// MARK: UICollectionView FlowLayout

extension PostViewController: UICollectionViewDelegateFlowLayout {
 
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let post = self.post else { return .zero }
    return PostCardCell.size(width: collectionView.width, post: post, isMessageTrimmed: false)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
  }
}
