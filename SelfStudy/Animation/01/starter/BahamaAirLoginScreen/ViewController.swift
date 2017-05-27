
import UIKit

// A delay function
// A delay function
func delay(_ seconds: Double, completion: @escaping ()->Void) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(seconds * 1000.0))) {
    completion()
  }
}

class ViewController: UIViewController {
  
  // MARK: IB outlets
  
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!
  
  // MARK: further UI
  
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  
  var statusPosition = CGPoint.zero
  
  // MARK: view controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true
    
    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)
    
    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)
    
    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let width = view.bounds.width
    heading.center.x -= width
    username.center.x -= width
    password.center.x -= width
    
    cloud1.alpha = 0
    cloud2.alpha = 0
    cloud3.alpha = 0
    cloud4.alpha = 0
    
    loginButton.center.y += 30
    loginButton.alpha = 0
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(
      withDuration: 0.5) { 
        self.heading.center.x += self.view.bounds.width
    }
    // TextField Animation
    UIView.animate(
      withDuration: 1.0,
      delay: 0.0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.0,
      options: [],
      animations: { 
        self.username.center.x += self.view.bounds.width
    }, completion: nil)
    UIView.animate(
      withDuration: 1.0,
      delay: 0.3,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.0,
      options: [],
      animations: { 
        self.password.center.x += self.view.bounds.width
    }, completion: nil)
    
    // Cloud Animation
    UIView.animate(
      withDuration: 0.5,
      delay: 0.5,
      options: [],
      animations: { 
        self.cloud1.alpha = 1
    }, completion: nil)
    UIView.animate(
      withDuration: 0.5,
      delay: 0.7,
      options: [],
      animations: {
        self.cloud2.alpha = 1
    }, completion: nil)
    UIView.animate(
      withDuration: 0.5,
      delay: 0.9,
      options: [],
      animations: {
        self.cloud3.alpha = 1
    }, completion: nil)
    UIView.animate(
      withDuration: 0.5,
      delay: 1.1,
      options: [],
      animations: {
        self.cloud4.alpha = 1
    }, completion: nil)
    
    // LoginButton Animation
    UIView.animate(
      withDuration: 1.5,
      delay: 0.5,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.0,
      options: [],
      animations: { 
        self.loginButton.center.y -= 30
        self.loginButton.alpha = 1
    }, completion: nil)
  }
  
  // MARK: further methods
  
  @IBAction func login() {
    view.endEditing(true)
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0.0,
      usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0.0,
      options: [],
      animations: { 
        self.loginButton.bounds.size.width += 80.0
    }, completion: nil)
    
    UIView.animate(
      withDuration: 0.33,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      options: [],
      animations: { 
        self.loginButton.center.y += 60.0
        self.loginButton.backgroundColor =
          UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        self.spinner.center =
          CGPoint(x: 40.0, y: self.loginButton.bounds.size.height / 2)
        self.spinner.alpha = 1.0
    }, completion: nil)
  }
  
  // MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }
  
}
