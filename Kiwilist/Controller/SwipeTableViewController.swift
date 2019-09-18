//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Majid Karimzadeh on 17/9/19.
//  Copyright © 2019 Uniq Artworks. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
    }
    
    // MARK:  tableView Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK:  Swipe Action
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
          
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                self.updateModel(at: indexPath)
                                
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "garbage-icon")
            
            return [deleteAction]
            
        }
        
        else {
            
            let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                // handle action by updating model with deletion
                
                self.editModel(at: indexPath)
            }
            // customize the action appearance
            editAction.image = UIImage(named: "edit-icon")
            
            editAction.backgroundColor = FlatYellowDark()
            
            return [editAction]
        
        }
    
    }
    
    // MARK:  Swipe with .destructive style
    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
    
    func updateModel(at indexPath: IndexPath) {
        //Update our dataModel
    }
    
    func editModel(at indexPath: IndexPath) {
        //Edit our dataModel
    }
    
}


