//
//  MainTabBarController.swift
//  Graygram
//
//  Created by Dabu on 2017. 6. 19..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
  
  // MARK: Properties
  
  let feedViewController = FeedViewController()
  let settingsViewController = UIViewController()
  
  /// 업로드 버튼 역할을 할 가짜 뷰 컨트롤러. 실제로 선택되지는 않는다.
  fileprivate let fakeUploadViewController = UIViewController()
  
  // MARK: - Initializer
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
    
    settingsViewController.title = "Settings"
    settingsViewController.tabBarItem.image = UIImage(named: "tab-settings")
    settingsViewController.tabBarItem.selectedImage = UIImage(named: "tab-settings-selected")
    
    fakeUploadViewController.tabBarItem.image = UIImage(named: "tab-upload")
    fakeUploadViewController.tabBarItem.imageInsets.top = 5           // 결과적으론 탭바이미지가 아래로 5point만큼 이동시킨 것처럼 보이게된다.
    fakeUploadViewController.tabBarItem.imageInsets.bottom = -5
    
    self.viewControllers = [
      UINavigationController(rootViewController: feedViewController),
      UINavigationController(rootViewController: settingsViewController),
      fakeUploadViewController,
    ]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: ImagePicker
  
  fileprivate func presentImagePickerController() {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    self.present(pickerController, animated: true, completion: nil)
  }
  
  fileprivate func presentCropViewController(image: UIImage) {
    let cropViewController = CropViewController(image: image)
    cropViewController.didFinishCropping = { image in
      guard let grayscaledImage = image.grayscaled() else { return }
      self.dismiss(animated: true, completion: nil)
      self.presentPostEditViewController(image: grayscaledImage)
    }
    
    let navigationController = UINavigationController(rootViewController: cropViewController)
    self.present(navigationController, animated: true, completion: nil)
  }
  
  fileprivate func presentPostEditViewController(image: UIImage) {
    let postEditViewController = PostEditViewController(image: image)
    let navigationControlelr = UINavigationController(rootViewController: postEditViewController)
    self.present(navigationControlelr, animated: true, completion: nil)
  }
}

// MARK: - UITabbarController Delegate

extension MainTabBarController: UITabBarControllerDelegate {
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
    ) -> Bool {
    if viewController === fakeUploadViewController {
      self.presentImagePickerController()
      return false
    } else {
      return true
    }
  }
}

// MARK: - UIImagePickerController Delegate

extension MainTabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : Any]
    ) {
    
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    picker.dismiss(animated: true, completion: nil)
    self.presentCropViewController(image: image)
  }
}
