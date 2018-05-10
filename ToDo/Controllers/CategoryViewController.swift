    //
    //  CategoryViewController.swift
    //  ToDo
    //
    //  Created by Abuzar Manzoor on 19/04/2018.
    //  Copyright © 2018 AbuzarManzoor. All rights reserved.
    //

    import UIKit
    import RealmSwift

    class CategoryViewController: UITableViewController {

        let realm = try! Realm()
        
        var categories: Results<Category>?
        
        @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
            var cTextField = UITextField()
            
            let alert = UIAlertController(title: "Add new Category" , message: "", preferredStyle: .alert)
           
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                
                // what will happen when the user clicked add button items
                
                let newCategory = Category()
                newCategory.name = cTextField.text!
                self.SaveCategory(category: newCategory)
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Category"
                cTextField = alertTextField
                //   print(alertTextField.text!)
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
        }
        
        
        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
                do{
                    try self.realm.write {
                        self.realm.delete((self.categories?[indexPath.row])!)
                    }
                }catch{
                    print("Error Saving Category: \(error)")
                }
                
                tableView.reloadData()
                
            }
            return [delete]
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            LoadCategories()
            
           
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
            
        }
        
        
        //MARK: table view source methods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories?.count ?? 1
        }
        
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
            // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
            
            cell.textLabel?.text = categories?[indexPath.row].name ?? "no Categries added yet"
            
           // cell.accessoryType = CategoryItem.done == true ? .checkmark : .none
            
            return cell
        }
        
        func SaveCategory(category: Category){
            do{
                try realm.write {
                    realm.add(category)
                }
            }catch{
                print("Error Saving Category: \(error)")
            }
            
            tableView.reloadData()
            
        }
        func LoadCategories(){
           categories =  realm.objects(Category.self)
            
            tableView.reloadData()
    }
        
        
         //MARK: table view delegate methods

    }
