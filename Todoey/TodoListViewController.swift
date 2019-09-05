//
//  ViewController.swift
//  Todoey
//
//  Created by Majid Karimzadeh on 5/9/19.
//  Copyright © 2019 Uniq Artworks. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Buy Milk", "Buy Eggs", "Use Butter"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
        
        //        if let cell = tableView.cellForRow(at: indexPath) {
        //            if cell.accessoryType == .checkmark {
        //                cell.accessoryType = .none
        //            } else {
        //                cell.accessoryType = .checkmark
        //            }
        //        }
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    
    
    //        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
    tableView.deselectRow(at: indexPath, animated: true)
}
}

