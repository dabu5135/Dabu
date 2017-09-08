
import UIKit

final class LoginViewController: UIViewController {
  
  // MARK: Properties
  
  fileprivate let usernameTextField = UITextField()
  fileprivate let passwordTextField = UITextField()
  fileprivate let loginButton = UIButton()
  
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(usernameTextField)
    view.addSubview(passwordTextField)
    view.addSubview(loginButton)
    
    usernameTextField.borderStyle = .roundedRect
    usernameTextField.placeholder = "Username"
    usernameTextField.autocapitalizationType = .none
    usernameTextField.autocorrectionType = .no
    usernameTextField.addTarget(
      self,
      action: #selector(textFieldDidChangeText(_:)),
      for: .editingChanged
    )
    passwordTextField.borderStyle = .roundedRect
    passwordTextField.placeholder = "Password"
    passwordTextField.isSecureTextEntry = true
    passwordTextField.autocapitalizationType = .none
    passwordTextField.autocorrectionType = .no
    passwordTextField.addTarget(
      self,
      action: #selector(textFieldDidChangeText(_:)),
      for: .editingChanged
    )
    loginButton.setTitle("Login", for: .normal)
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    loginButton.backgroundColor = loginButton.tintColor
    loginButton.layer.cornerRadius = 5
    loginButton.addTarget(self,
                          action: #selector(loginButtonDidTap(_:)),
                          for: .touchUpInside
    )
    usernameTextField.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
      make.left.equalTo(30)
      make.right.equalTo(-30)
      make.height.equalTo(30)
    }
    passwordTextField.snp.makeConstraints { make in
      make.top.equalTo(usernameTextField.snp.bottom).offset(10)
      
      make.left.equalTo(usernameTextField)
      make.right.equalTo(usernameTextField)
      make.height.equalTo(usernameTextField)
//      make.left.equalTo(usernameTextField.snp.left)
//      make.right.equalTo(usernameTextField.snp.right)
//      make.height.equalTo(usernameTextField.snp.height)
    }
    loginButton.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(10)
      
      make.left.right.height.equalTo(usernameTextField)
//      make.left.equalTo(usernameTextField)
//      make.right.equalTo(usernameTextField)
//      make.height.equalTo(usernameTextField)
    }
  }
  
  deinit {
    print("LoginViewController is dealloc!!")
  }
  
  // MARK: - Actions
  
  fileprivate dynamic func loginButtonDidTap(_ sender: UIButton) {
    // do validation
    guard let username = usernameTextField.text, !username.isEmpty else { return }
    guard let password = passwordTextField.text, !password.isEmpty else { return }
    login(username: username, password: password)
  }
  
  fileprivate dynamic func textFieldDidChangeText(_ sender: UITextField) {
    sender.backgroundColor = .white
  }
  
  // MARK: - Login
  
  fileprivate func login(username: String, password: String) {
    usernameTextField.isEnabled = false
    passwordTextField.isEnabled = false
    loginButton.isEnabled = false
    loginButton.alpha = 0.4
    
    AuthService.login(
      username: username,
      password: password) { [weak self] response in
        guard let `self` = self else { return }
        
        self.usernameTextField.isEnabled = true
        self.passwordTextField.isEnabled = true
        self.loginButton.isEnabled = true
        self.loginButton.alpha = 1
        
        switch response.result {
        case .success(let value):
          print("로그인 성공 \(value)")
          AppDelegate.instance?.presentMainScreen()
        case .failure(let error):
          print("로그인 실패❌ \(error)")
          if let errorInfo = response.errorInfo() {
            switch errorInfo.field {
            case "username":
              self.usernameTextField.becomeFirstResponder()
              self.usernameTextField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            case "password":
              self.passwordTextField.becomeFirstResponder()
              self.passwordTextField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            default:
              break
            }
          }
        }
      }
  }
  
}
