
import UIKit

final class FeedViewController: UIViewController {

  fileprivate enum ViewMode {
    case card
    case tile
  }
  
  // MARK: Properties
  
  private var posts: [Post] = []
  private var nextURLString: String?
  private var isLoading: Bool = false
  private var viewMode: ViewMode = .card {
    didSet {
      switch self.viewMode {
      case .card:
        self.navigationItem.leftBarButtonItem = self.tileButtonItem
      case .tile:
        self.navigationItem.leftBarButtonItem = self.cardButtonItem
      }
      self.collectionView.reloadData()
    }
  }
  
  private let tileButtonItem = UIBarButtonItem(
    image: UIImage(named: "icon-tile"),
    style: .plain,
    target: nil,
    action: nil
  )
  private let cardButtonItem = UIBarButtonItem(
    image: UIImage(named: "icon-card"),
    style: .plain,
    target: nil,
    action: nil
  )
  private let refreshControl = UIRefreshControl()
  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  
  // MARK: Initializers
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.navigationItem.title = "Graygram"
    
    self.tabBarItem.title = "Feed" // 기본값은 self.title 이 들어간다
    self.tabBarItem.image = UIImage(named: "tab-feed")
    self.tabBarItem.selectedImage = UIImage(named: "tab-feed-selected")
    
    self.tileButtonItem.target = self
    self.tileButtonItem.action = #selector(tileButtonItemDidTap)
    self.cardButtonItem.target = self
    self.cardButtonItem.action = #selector(cardButtonItemDidTap)
    
    self.navigationItem.leftBarButtonItem = self.tileButtonItem   // 처음에는 card형태이므로 tile버튼이 보여야한다
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("Feed View Controller is dealloc")
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(collectionView)
    configureCollectionView()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(postDidLike),
      name: .postDidLike,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(postDidUnLike),
      name: .postDidUnLike,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(postDidCreate),
      name: .postDidCreate,
      object: nil
    )
    
    fetchPosts(paging: .refresh)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: configure
  
  private func configureCollectionView() {
    
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    collectionView.backgroundColor = .white
    collectionView.register(
      PostCardCell.self,
      forCellWithReuseIdentifier: "cardCell"
    )
    collectionView.register(
      CollectionActivityIndicatorView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "activityIndicatorView"
    )
    collectionView.register(
      PostTileCell.self,
      forCellWithReuseIdentifier: "tileCell"
    )
    refreshControl.addTarget(
      self,
      action: #selector(refreshControlDidChangeValue),
      for: .valueChanged
    )
    
    collectionView.addSubview(refreshControl)
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  @objc func refreshControlDidChangeValue() {
    fetchPosts(paging: .refresh)
  }
  
  // MARK: Fetch
  
  private func fetchPosts(paging: Paging) {
    guard !isLoading else { return }
    self.isLoading = true
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    FeedService.feed(paging: paging) { [weak self] response in
      guard let `self` = self else { return }
      self.isLoading = false
      self.refreshControl.endRefreshing()
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      switch response.result {
      case .success(let feed):
        let newPosts = feed.posts ?? []
        switch paging {
        case .refresh:
          self.posts = newPosts
        case .next:
          self.posts += newPosts
        }
        self.nextURLString = feed.nextURLString
        self.collectionView.reloadData()
      case .failure(let error):
        print(error)
      }
    }
    
  }
  
  // MARK: Selector
  // Notification
  @objc private func postDidLike(notification: Notification) {
    guard let postID = notification.userInfo?["postID"] as? Int else { return }
    guard let index = self.posts.index(where: { $0.id == postID }) else { return }
    
    var newPost = self.posts[index]
    newPost.isLiked = true
    newPost.likeCount! += 1
    self.posts[index] = newPost    
  }
  
  @objc private func postDidUnLike(notification: Notification) {
    guard let postID = notification.userInfo?["postID"] as? Int else { return }
    guard let index = self.posts.index(where: { $0.id == postID}) else { return }

    var newPost = self.posts[index]
    newPost.isLiked = false
    newPost.likeCount! -= 1
    self.posts[index] = newPost
  }
  
  @objc private func postDidCreate(notification: Notification) {
    guard let post = notification.userInfo?["post"] as? Post else { return }
    self.posts.insert(post, at: 0)
    self.collectionView.reloadData()
    //self.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
  }
  
  // BarButtonItem
  @objc private func tileButtonItemDidTap() {
    self.viewMode = .tile
  }
  
  @objc private func cardButtonItemDidTap() {
    self.viewMode = .card
  }
}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
  
  func numberOfSections(
    in collectionView: UICollectionView
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.posts.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch self.viewMode {
    case .card:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: "cardCell",
        for: indexPath
      ) as! PostCardCell
      cell.configure(post: self.posts[indexPath.item])
      return cell
    case .tile:
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: "tileCell",
        for: indexPath
      ) as! PostTileCell
      let post = self.posts[indexPath.item]
      cell.configure(post: post)
      cell.didTap = {
        let postViewController = PostViewController(postID: post.id)
        self.navigationController?.pushViewController(postViewController, animated: true)
      }
      return cell
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind
    kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    
    return collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "activityIndicatorView",
      for: indexPath
    )
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch self.viewMode {
    case .card:
      let post = self.posts[indexPath.item]
      return PostCardCell.size(width: collectionView.frame.size.width, post: post)
    case .tile:
      return PostTileCell.size(width: collectionView.width / 3)
    }
    
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    
    // 더보기 요청이 불가능 한 경우 (마지막 페이지에 도달)
    if self.nextURLString == nil && !self.posts.isEmpty {
      return .zero
    } else {
      return CGSize(width: collectionView.width, height: 44.0)
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch self.viewMode {
    case .card:
      return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    case .tile:
      return UIEdgeInsets.zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch self.viewMode {
    case .card:
      return 20
    case .tile:
      return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
}

// MARK: - UIScrollView Delegate

extension FeedViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.contentSize.height > 0  else { return }
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.height
    let isReachedBottom = contentOffsetBottom >= scrollView.contentSize.height - 300
    if let nextURLString = self.nextURLString, isReachedBottom {
      fetchPosts(paging: .next(nextURLString))
    }
  }
  
}
