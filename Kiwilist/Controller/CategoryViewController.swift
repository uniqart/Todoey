//
//  CategoryViewController.swift
//  Todoey
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
        
    }
    
    // MARK:  Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What will happen once the user clicks the add button on the alert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
//            let colourArray = ["55efc4", "81ecec", "74b9ff", "a29bfe", "00b894", "00cec9", "0984e3", "6c5ce7", "ffeaa7", "fab1a0", "ff7675", "fd79a8", "fdcb6e", "e17055", "e84393", "f6e58d", "ffbe76", "ff7979", "badc58", "f9ca24", "f0932b", "eb4d4b", "6ab04c", "7ed6df", "e056fd", "686de0", "30336b", "22a6b3", "be2edd", "4834d4", "f3a683", "f7d794", "778beb", "e77f67", "cf6a87", "f19066", "f5cd79", "546de5", "e15f41", "c44569", "786fa6", "f8a5c2", "3dc1d3", "e66767"]
            
            
            //            let randomIndex = Int(arc4random_uniform(UInt32(colourArray.count)))
            
            newCategory.color = (HexColor(self.selectedColour ?? "#fff")?.hexValue() ?? "fff")
            
            // newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .yes
            
            let colorPickerframe = CGRect(x: 30,
                                          y: 30,
                                          width: self.view.frame.size.width - 60,
                                          height: 30)
            let colorPicker = ColorPickerView(frame: colorPickerframe)
            colorPicker.didChangeColor = { color in
                //Use color and do the requied.
                self.selectedColour = color?.hexValue()
            }
            
            alert.view.addSubview(colorPicker)
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }

    }
    
    @objc func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
