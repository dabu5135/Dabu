
import UIKit

import Kingfisher
import ManualLayout
import SnapKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Properties
  
  var window: UIWindow?
  
  class var instance: AppDelegate? {
    return UIApplication.shared.delegate as? AppDelegate
  }
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    self.configureAppearance()
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()
    
    let splashViewController = SplashViewController()
    let navigationController = UINavigationController(rootViewController: splashViewController)
    window.rootViewController = navigationController
    self.window = window
    
    
    return true
  }

  // MARK: PresentViewController
  
  func presentMainScreen() {
    let mainTabBarController = MainTabBarController()
    self.window?.rootViewController = mainTabBarController
  }
  
  func presentLoginScreen() {
    let loginViewController = LoginViewController()
    let navigationController = UINavigationController(rootViewController: loginViewController)
    self.window?.rootViewController = navigationController
  }
  
  // MARK: Configure UI
  
  fileprivate func configureAppearance() {
    UINavigationBar.appearance().tintColor = .black
    UIBarButtonItem.appearance().tintColor = .black
    UITabBar.appearance().tintColor = .black
  }
}

