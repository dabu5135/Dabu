//
//  TaskListViewController.swift
//  TodoBox
//
//  Created by Dabu on 2017. 5. 22..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit

let taskCellIdentifier = "TaskCell"
let taskEditSegueIdentifier = "TaskEditSegue"
let tasksUserDefaultsKey = "TaskUserDefaultsKey"

class TaskListViewController: UIViewController {
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var editButton: UIBarButtonItem!
  
  
  var tasks: [Task] = [] {
    didSet {
      // save
      saveAll()
    }
  }

  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.loadAll()
  }
  
  
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
  
  // MARK: Save & Load
  /// 모든 할 일 목록을 UserDefaults에 저장
  func saveAll() {
    
    // 1. [Task] -> [[String : Any]]로 변환
    /*
     let array: [[String : Any]] = self.tasks.map { $0.toDictionary() }
     */
    
    let taskDictionary = self.tasks.map {
      ["title" : $0.title,
       "isDone" : $0.isDone
      ]
    }
    // 2. [[String : Any]]를 UserDefaults에 저장
    let userDefaults = UserDefaults.standard
    userDefaults.set(taskDictionary, forKey: tasksUserDefaultsKey)
    
    // 3. UserDefaults 동기화
    userDefaults.synchronize()
  }
  
  
  /// UserDefaults에서 할 일 목록을 불러옵니다.
  func loadAll() {
    // 1. UserDefaults에서 [[String : Any]]를 꺼내옴
    let userDafults = UserDefaults.standard
    guard let array = userDafults.array(forKey: tasksUserDefaultsKey) as? [[String : Any]] else { return }

//    self.tasks = array.map { ($0["title"] as? Task)?.toDictionary() }
    // 2. [[String : Any]] -> [Task]
//    var tasks: [Task] = []
//    for dict in array {
//      if let task = Task(dictionary: dict) {
//        tasks.append(task)
//      }
//    }
    
    self.tasks = array.flatMap { Task(dictionary: $0) }
  
  }
  
  
  // MARK: IBActions
  
  @IBAction func editButtonDidSelect(_ sender: UIBarButtonItem) {
    self.navigationItem.leftBarButtonItem = self.doneButton
    self.tableView.setEditing(true, animated: true)
  }
  
  @IBAction func doneButtonDidSelect(_ sender: UIBarButtonItem) {
    self.navigationItem.leftBarButtonItem = self.editButton
    self.tableView.setEditing(false, animated: true)
  }
}

// MARK: - TableView DataSource

extension TaskListViewController: UITableViewDataSource {
  
  // MARK: Source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier, for: indexPath)
    let task = tasks[indexPath.row]
    cell.textLabel?.text = task.title
    cell.detailTextLabel?.text = task.memo
    task.isDone ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
    
    return cell
  }
  
  // MARK: Reordering
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView,
                 moveRowAt sourceIndexPath: IndexPath,
                 to destinationIndexPath: IndexPath) {
    
    let task = tasks[sourceIndexPath.row]
    tasks.remove(at: sourceIndexPath.row)
    tasks.insert(task, at: destinationIndexPath.row)
    
    /*
     tableView(_:canMoveRowAt:) -> Bool 이 메소드는 UI의 변경을 먼저하고 호출되기 때문에 다른 메소드와는 달리
                                  마지막에 UI를 업데이트(=reload)안해줘도 된다!! 굳굳!!
     */
//    tableView.reloadData()
  }
  
  // MARK: Others
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCellEditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.tasks.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
  }
  
  
}

// MARK: - TableView Delegate

extension TaskListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let oldTask = tasks[indexPath.row]
    let newTask = Task(title: oldTask.title, isDone: !oldTask.isDone, memo: oldTask.memo)
    
    tasks[indexPath.row] = newTask
    self.tableView.reloadRows(at: [indexPath], with: .fade)
  }
  
}

