//
//  CategoryViewController.swift
//  Kiwilist
//
//  Created by Majid Karimzadeh on 16/9/19.
//  Copyright © 2019 Uniq Artworks. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import ColorPickerSlider

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    var selectedColour : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    // MARK:  TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    // MARK:  TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK:  Data Manupulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK:  Delete Category
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
    
    // MARK:  Update Category
    override func editModel(at indexPath: IndexPath) {
        
        if let categoryForEdit = self.categories?[indexPath.row] {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Edit Your Category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Update Category", style: .default) { (action) in
                //What will happen once the user clicks the add button on the alert
                do {
                    try self.realm.write {
                        categoryForEdit.name = textField.text!
                        categoryForEdit.color = (HexColor(self.selectedColour ?? "#f9ca24")?.hexValue() ?? "f9ca24")
                    }
                } catch {
                    print("Error updating category \(error)")
                }
                
                self.tableView.reloadData()
                
            }
            
            alert.addTextField { (field) in
                field.placeholder = "Category name"
                textField = field
                textField.autocapitalizationType = .words
                textField.autocorrectionType = .yes
                
                // Colour Slider for Category Colour
                let colorPickerframe = CGRect(x: 0,
                                              y: 85,
                                              width: alert.view.frame.size.width - 105,
                                              height: 30)
                let colorPicker = ColorPickerView(frame: colorPickerframe)
                colorPicker.didChangeColor = { color in
                    //Use color and do the requied.
                    self.selectedColour = color?.hexValue()
                    
                    // Preview the colour on the alert button
                    alert.view.tintColor = UIColor(hexString: self.selectedColour ?? FlatSkyBlue().hexValue())
                    
                }
                
                alert.view.addSubview(colorPicker)
            }
            
            alert.addAction(action)
            
            present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
            }
            
        }
    }
    
    
    
    // MARK:  Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What will happen once the user clicks the add button on the alert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            newCategory.color = (HexColor(self.selectedColour ?? "#f9ca24")?.hexValue() ?? "f9ca24")
            
            self.save(category: newCategory)
        }
        
        
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .yes
            
            // Colour Slider for Category Colour
            let colorPickerframe = CGRect(x: 0,
                                          y: 85,
                                          width: alert.view.frame.size.width - 105,
                                          height: 30)
            let colorPicker = ColorPickerView(frame: colorPickerframe)
            colorPicker.didChangeColor = { color in
                //Use color and do the requied.
                self.selectedColour = color?.hexValue()
                
                // Preview the colour on the alert button
                alert.view.tintColor = UIColor(hexString: self.selectedColour ?? FlatSkyBlue().hexValue())
                
            }
            
            alert.view.addSubview(colorPicker)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
        }
        
    }
    
}
