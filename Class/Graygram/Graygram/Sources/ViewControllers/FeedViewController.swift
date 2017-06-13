//
//  ViewController.swift
//  Graygram
//
//  Created by Dabu on 2017. 5. 31..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit
import Alamofire


final class FeedViewController: UIViewController {

  let feedURL = "https://api.graygram.com/feed?limit=3"
  let collectionViewCellIdentifier = "cardCell"
  let collectionViewReusableViewIdentifier = ""
  
  // MARK: Properties
  fileprivate var posts: [Post] = []
  fileprivate var nextURLString: String?
  fileprivate var isLoading: Bool = false
  
  fileprivate let refreshControl = UIRefreshControl()
  fileprivate let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(collectionView)
    configurationCollectionView()
    fetchPosts()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: configure
  fileprivate func configurationCollectionView() {
    
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    collectionView.backgroundColor = .white
    collectionView.register(
      PostCardCell.self,
      forCellWithReuseIdentifier: collectionViewCellIdentifier
    )
    collectionView.register(
      CollectionActivityIndicatorView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "activityIndicatorView"
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
  
  func refreshControlDidChangeValue() {
    fetchPosts()
  }
  
  // MARK: Fetch
  fileprivate func fetchPosts(isMore: Bool = false) {
    guard !isLoading else { return }
    
    let urlString: String
    
    if !isMore {
      urlString = feedURL
    } else if let nextURLString = self.nextURLString {
      urlString = nextURLString
    } else {
      return
    }
    
    self.isLoading = true
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    Alamofire.request(urlString)
      .responseJSON { response in
        self.isLoading = false
        self.refreshControl.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        switch response.result {
        case .success(let value):
          guard let json = value as? [String : Any] else { return }
          guard let jsonArray = json["data"] as? [[String : Any]] else { return }
          
          let newPosts = [Post](JSONArray: jsonArray)
          // Array<Post>.init(JSONArray: jsonArray) 와 동일
          
          if !isMore {
            self.posts = newPosts
          } else {
            self.posts += newPosts
          }

          let paging = json["paging"] as? [String: Any]
          self.nextURLString = paging?["next"] as? String
          
          self.collectionView.reloadData()
          
        case .failure(let error):
          print(error)
        }
    }
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
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: collectionViewCellIdentifier,
      for: indexPath
      ) as! PostCardCell
    
    cell.configure(post: self.posts[indexPath.item])
    return cell
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
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let post = self.posts[indexPath.item]
    return PostCardCell.size(width: collectionView.frame.size.width, post: post)
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
    
    return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
    return 20.0
  }
}

// MARK: - UIScrollView Delegate
extension FeedViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.contentSize.height > 0  else { return }
    
    let contentOffsetBottom = scrollView.contentOffset.y + scrollView.height
    if contentOffsetBottom >= scrollView.contentSize.height - 300 {
      fetchPosts(isMore: true)
    }
  }
  
}
