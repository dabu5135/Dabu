//
//  TaskEditViewController.swift
//  TodoBox
//
//  Created by Dabu on 2017. 5. 24..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit



class TaskEditViewController: UIViewController {
  
  // Properties
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textView: UITextView!
  
  var didAddTask: ((Task) -> Void)?
  
  // MARK: ViewController Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let scale = UIScreen.main.scale
    textView.layer.borderWidth = CGFloat(1.0 / scale)
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.cornerRadius = CGFloat(5.0 / scale)
  }
  
  // MARK: IBActions
  @IBAction func tappedCancelButton(_ sender: UIBarButtonItem) {
    self.textField.resignFirstResponder()
    
    if textField.text?.isEmpty == true {
      self.dismiss(
        animated: true,
        completion: nil
      )
      return
    }
    
    let alertController = UIAlertController(
      title: "정말 닫으실 건가요?",
      message: "내용이 유실될 수 있습니다.",
      preferredStyle: .alert
    )
    
    let deleteAction = UIAlertAction(
      title: "작성 취소",
      style: .destructive) { action in
        self.dismiss(animated: true, completion: nil)
    }
    
    let cancelAction = UIAlertAction(
      title: "계속 작성",
      style: .cancel) { _ in
        self.textField.becomeFirstResponder()
    }
    
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController,
                 animated: true,
                 completion: nil)
    
  }
  
  @IBAction func tappedDoneButton(_ sender: UIBarButtonItem) {
    
    guard let title = textField.text, !title.isEmpty else {
      shakeTextField()
      return
    }
    let task = Task(title: title, memo: textView.text)
    didAddTask?(task)
    textField.resignFirstResponder()
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Others
  func shakeTextField() {
    
    UIView.animate(
      withDuration: 0.15,
      animations: {
        self.textField.frame.origin.x += 10
      },
      completion: { _ in
        UIView.animate(
          withDuration: 0.15,
          animations: {
            self.textField.frame.origin.x -= 20
        },
          completion: { _ in
            UIView.animate(
              withDuration: 0.15,
              animations: {
                self.textField.frame.origin.x += 10
            },
              completion: nil
            )
        }
        )
      }
    )
  }
  
}
