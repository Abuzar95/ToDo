    //
    //  ViewController.swift
    //  ToDo
    //
    //  Created by Abuzar Manzoor on 04/04/2018.
    //  Copyright © 2018 AbuzarManzoor. All rights reserved.
    //

    import UIKit
    import RealmSwift

    class ToDoListViewController: UITableViewController {
        
         let realm = try! Realm()
        var todoItems: Results<Item>?
        var selectedCategory : Category?{
            didSet{
                loadItems()
            }
        }
        
        
       
        
        override func viewDidLoad() {
            super.viewDidLoad()
           // print(dataFilePath)
            
            
         //  loadItems()
            }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        //MARK: - tableView data source
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoCell")

            
          
            if let item = todoItems?[indexPath.row]{
                cell.textLabel?.text = item.title
                cell.accessoryType = item.checked == true ? .checkmark : .none
            }else{
                cell.textLabel?.text = "No Item Added"
            }
            

        return cell
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
        
        //MARK:- Table view delegate

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
            if let item = todoItems?[indexPath.row] {
                do{
                try realm.write {
                    item.checked = !item.checked
                    //realm.delete(item)
                }
                }catch{
                    print("Error Saving data : \(error)")
                }
            }
                tableView.reloadData()
            
            // print(ItemArray[indexPath.row].title!)
            
    //       // ItemArray[indexPath.row].done = !ItemArray[indexPath.row].done
    //        saveItems()
    //       // tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
           
            
        }
        
    //    //Mark - Table view delegate - Delete NSManagedObject
    //
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //       // print(ItemArray[indexPath.row].title!)
    //
    //        context.delete(ItemArray[indexPath.row])
    //        ItemArray.remove(at: indexPath.row)
    //
    //       // ItemArray[indexPath.row].done = !ItemArray[indexPath.row].done
    //        saveItems()
    //        // tableView.reloadData()
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //
    //    }
        
        @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new Item" , message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                // what will happen when the user clicked add button items
               
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error loading Data: \(error)")
                    }
                }
              self.tableView.reloadData()
                

                     }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Item"
                textField = alertTextField
                //   print(alertTextField.text!)
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        //MARK: - Model Manupulation method

        func loadItems(){
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
            
    //       //let request: NSFetchRequest<Item> = Item.fetchRequest()
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
    //        if let additionalPredicate = predicate{
    //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    //        }else{
    //            request.predicate = categoryPredicate
    //        }
    //
    //        do{
    //            ItemArray = try context.fetch(request)
    //        }catch{
    //            print("Error Loading: \(error)")
    //        }
        }
        
    }
    //MARK: - Search bar Methods
    extension ToDoListViewController : UISearchBarDelegate{
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            

        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0{
           loadItems()
           tableView.reloadData()

            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
            }
        else{
                searchBarSearchButtonClicked(searchBar)
            }
    }
    }
