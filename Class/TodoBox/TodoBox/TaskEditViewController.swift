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
    
  }
  
  // MARK: IBActions
  @IBAction func tappedCancelButton(_ sender: UIBarButtonItem) {
    
    textField.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func tappedDoneButton(_ sender: UIBarButtonItem) {
    
    guard let title = textField.text, !title.isEmpty else {
      shakeTextField()
      return
    }
    let task = Task(title: title)
    didAddTask?(task)
    textField.resignFirstResponder()
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Others
  func shakeTextField() {
    
    UIView.animate(
      withDuration: 0.3,
      animations: {
        self.textField.frame.origin.x += 10
      },
      completion: { _ in
        UIView.animate(
          withDuration: 0.3,
          animations: {
            self.textField.frame.origin.x -= 20
        },
          completion: { _ in
            UIView.animate(
              withDuration: 0.3,
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
