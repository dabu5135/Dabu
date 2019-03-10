//
//  CropViewController.swift
//  Graygram
//
//  Created by Dabu on 2017. 6. 21..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit

final class CropViewController: UIViewController {
  
  var didFinishCropping: ((UIImage) -> Void)?
  
  private let scrollView = UIScrollView()
  private let imageView = UIImageView()
  
  private let topCoverView = UIView()
  private let cropAreaView = UIView()
  private let bottomCoverView = UIView()
  
  // MARK: Initializers
  
  init(image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    self.imageView.image = image
    self.cropAreaView.layer.borderColor = UIColor.lightGray.cgColor
    self.cropAreaView.layer.borderWidth = 1 / UIScreen.main.scale   // device에 따라 1px만 사용하기 위함
    
    self.topCoverView.backgroundColor = .white
    self.topCoverView.alpha = 0.9
    self.bottomCoverView.backgroundColor = .white
    self.bottomCoverView.alpha = 0.9
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonItemDidTap)
    )
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(cancelButtonItemDidTap)
    )
    
    // navigationController는 navigationController에 루트뷰 컨트롤러로 할당되었을 때 사용가능하므로
    // 이니셜라이져에서는 사용불가능하다. 네비게이션컨트롤러를 사용하려면 viewDidLoad 이후에 사용하자.
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK : View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.automaticallyAdjustsScrollViewInsets = false
    
    self.scrollView.showsVerticalScrollIndicator = false
    self.scrollView.showsHorizontalScrollIndicator = false
    self.scrollView.alwaysBounceVertical = true
    self.scrollView.alwaysBounceHorizontal = true
    self.scrollView.maximumZoomScale = 3
    self.scrollView.delegate = self
    
    self.topCoverView.isUserInteractionEnabled = false
    self.bottomCoverView.isUserInteractionEnabled = false
    self.cropAreaView.isUserInteractionEnabled = false
    
    self.scrollView.addSubview(self.imageView)
    self.view.addSubview(self.scrollView)
    self.view.addSubview(self.topCoverView)
    self.view.addSubview(self.bottomCoverView)
    self.view.addSubview(self.cropAreaView)
    
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.cropAreaView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(self.cropAreaView.snp.width)
      make.centerY.equalToSuperview()
    }
    self.topCoverView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(self.cropAreaView.snp.top)
    }
    self.bottomCoverView.snp.makeConstraints { make in
      make.bottom.left.right.equalToSuperview()
      make.top.equalTo(self.cropAreaView.snp.bottom)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if self.imageView.size == .zero {
      self.initializeContentSize()
    }
  }
  
  // MARK : Configure Content
  
  private func initializeContentSize() {
    guard let image = self.imageView.image else { return }
    let imageWidth = image.size.width
    let imageHeight = image.size.height
    
    if imageWidth > imageHeight {                       // 가로로 긴 이미지 (landscape)
      self.imageView.height = self.cropAreaView.height
      self.imageView.width = self.cropAreaView.height * (imageWidth / imageHeight)
    } else if imageWidth < imageHeight {                // 세로로 긴 이미지 (portrait)
      self.imageView.width = self.cropAreaView.width
      self.imageView.height = self.cropAreaView.width * (imageHeight / imageWidth)
    } else {                                            // 정사각형
      self.imageView.size = self.cropAreaView.size
    }
    
    self.scrollView.contentInset.top = (self.scrollView.height - self.cropAreaView.height) / 2
    self.scrollView.contentInset.bottom = self.scrollView.contentInset.top
    self.scrollView.contentSize = self.imageView.size
    self.centerContent()
  }
  
  private func centerContent() {
    self.scrollView.contentOffset.x = (self.scrollView.contentSize.width - self.scrollView.width) / 2
    self.scrollView.contentOffset.y = (self.scrollView.contentSize.height - self.scrollView.height) / 2
  }
  
  // MARK: Actions
  
  @objc private func doneButtonItemDidTap(_ sender: UIBarButtonItem) {
    guard let image = self.imageView.image else { return }
    
    // cropAreaView.frame을 imageVIew.frame과 같은 좌표계로 변경
    var rect = self.scrollView.convert(self.cropAreaView.frame, from: self.cropAreaView.superview)
    let widthRatio = image.size.width / self.imageView.width
    let heightRatio = image.size.height / self.imageView.height
    
    rect.origin.x *= widthRatio
    rect.origin.y *= heightRatio
    rect.size.width *= widthRatio
    rect.size.height *= heightRatio
    
    if let croppedCGImage = image.cgImage?.cropping(to: rect) {
      let croppedImage = UIImage(cgImage: croppedCGImage)
      self.didFinishCropping?(croppedImage)
    }
  }
  
  @objc private func cancelButtonItemDidTap(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - UIScrollView Delegate

extension CropViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }
}
