//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Abuzar Manzoor on 19/04/2018.
//  Copyright © 2018 AbuzarManzoor. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

     var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var cTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category" , message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // what will happen when the user clicked add button items
            
            let CategoryItem = Category(context: self.context)
            CategoryItem.name = cTextField.text!
            //newItem.done = false
            
            self.categoryArray.append(CategoryItem)
            // self.defaults.setValue(self.ItemArray, forKey: "ToDoListArray")
            self.SaveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            cTextField = alertTextField
            //   print(alertTextField.text!)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCategory()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: table view source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
       // cell.accessoryType = CategoryItem.done == true ? .checkmark : .none
        
        return cell
    }
    
    func SaveCategory(){
        do{
            try context.save()
        }catch{
            print("Error Saving Category: \(error)")
        }
        
        tableView.reloadData()
        
    }
    func LoadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
           categoryArray = try context.fetch(request)
        }catch{
            print("Error Loading Category: \(error)")
        }
    }
    
}
    
    
     //MARK: table view delegate methods


