

import UIKit
import PlaygroundSupport


//: Protocol & Extension 예제 - Shakable

protocol Shakable { }

extension Shakable where Self: UIView {
  
  func shake() {
    let animation = CABasicAnimation(keyPath: "position")
    animation.repeatCount = 5
    animation.autoreverses = true
    animation.duration = 0.1
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4,
                                                 y: self.center.y)
    )
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4,
                                                   y: self.center.y)
    )
    self.layer.add(animation, forKey: "positoin")
  }
}


class SomeView: UIButton, Shakable { }



class SomViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    let foo = SomeView()
    foo.setTitle("sdfsdf", for: .normal)
    foo.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
    foo.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    foo.backgroundColor = .red
    view.addSubview(foo)
  }
  
  
  @objc func didTapButton(_ sender: SomeView) {
    
    sender.shake()
  }
}

PlaygroundPage.current.liveView = SomViewController()



