//
//  MasterViewController.swift
//  StartSwift
//
//  Created by Dabu on 2017. 3. 30..
//  Copyright © 2017년 Dabu. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}



// MARK: - TableView DataSource

extension MasterViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        cell.textLabel!.text = "test!!"
        
        return cell
    }
}
