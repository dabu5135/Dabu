//
//  TaskListViewController.swift
//  TodoBox
//
//  Created by Dabu on 2017. 5. 22..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit

let taskCellIdentifier = "taskCell"
let taskEditSegueIdentifier = "TaskEditSegue"

class TaskListViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  
  var tasks: [Task] = [
    Task(title: "청소하기", isDone: true),
    Task(title: "빨래하기"),
    Task(title: "이슈 생성하기")
  ]
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }
  
  
  // MARK: IBActions
  
  // MARK: Others
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nav = segue.destination as? UINavigationController, segue.identifier == taskEditSegueIdentifier {
      if let nextViewController = nav.viewControllers.first as? TaskEditViewController {
        
        nextViewController.didAddTask = { [weak self] task in
          guard let `self` = self else { return }
          self.tasks.append(task)
          self.tableView.reloadData()
        }
      }
    }
  }
  
}

// MARK: - TableView DataSource

extension TaskListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier, for: indexPath)
    let task = tasks[indexPath.row]
    cell.textLabel?.text = task.title
    task.isDone ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
    
    return cell
  }
  
  // Reordering
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
}

// MARK: - TableView Delegate

extension TaskListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let oldTask = tasks[indexPath.row]
    let newTask = Task(title: oldTask.title, isDone: !oldTask.isDone)
    
    tasks[indexPath.row] = newTask
    self.tableView.reloadRows(at: [indexPath], with: .fade)
  }
  
}

