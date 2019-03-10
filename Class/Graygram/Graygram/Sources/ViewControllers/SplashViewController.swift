
import UIKit

final class SplashViewController: UIViewController {
  
  private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  
  // MARK: - ViewController Lify Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(activityIndicatorView)
    
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    activityIndicatorView.startAnimating()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    AppDelegate.instance?.presentMainScreen()
//    UserService.me { response in
//      switch response.result {
//      case .success(let value):
//        print("내 프로필 정보 받아오기 성공 ⭕️ \(value)")
//        AppDelegate.instance?.presentMainScreen()
//
//      case .failure(let error):
//        print("내 프로필 정보 받아오기 실패 ❌ \(error)")
//        AppDelegate.instance?.presentLoginScreen()
//      }
//    }
    
  }
  
}
