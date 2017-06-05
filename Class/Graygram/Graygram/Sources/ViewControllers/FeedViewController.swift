//
//  ViewController.swift
//  Graygram
//
//  Created by Dabu on 2017. 5. 31..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit
import Alamofire


let feedURL = "https://api.graygram.com/feed"

let collectionViewCellIdentifier = "cardCell"

final class FeedViewController: UIViewController {
  
  // MARK: Properties
  fileprivate var posts: [Post] = []
  fileprivate let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configurationCollectionView()
    self.view.addSubview(collectionView)
    fetchPosts()
  }
  
  fileprivate func configurationCollectionView() {
    
    collectionView.frame = self.view.frame
    collectionView.backgroundColor = .white
    collectionView.register(
      PostCardCell.self,
      forCellWithReuseIdentifier: collectionViewCellIdentifier
    )
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  fileprivate func fetchPosts() {
    Alamofire.request(feedURL)
      .responseJSON { response in
        switch response.result {
        case .success(let value):
          guard let json = value as? [String : Any] else { return }
          guard let jsonArray = json["data"] as? [[String : Any]] else { return }
          let newPosts = [Post](JSONArray: jsonArray)
          self.posts = newPosts
          
          DispatchQueue.main.async { _ in
            self.collectionView.reloadData()
          }
          
        case .failure(let error):
          print(error)
        }
      }
  }
  
}


// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    return UICollectionViewCell()
  }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = collectionView.frame.size.width
    return CGSize(width: width, height: width)
  }
}
