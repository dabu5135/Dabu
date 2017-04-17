//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Dabu on 2017. 4. 17..
//  Copyright © 2017년 Razeware. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
            "No Icon",
            "Appointments",
            "Birthdays",
            "Chores",
            "Drinks",
            "Folder",
            "Groceries",
            "Inbox",
            "Photos",
            "Trips" ]
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension IconPickerViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
