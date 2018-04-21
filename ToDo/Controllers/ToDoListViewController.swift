//
//  ViewController.swift
//  ToDo
//
//  Created by Abuzar Manzoor on 04/04/2018.
//  Copyright © 2018 AbuzarManzoor. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //let defaults = UserDefaults.standard
     //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var ItemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let item = ItemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
       
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemArray.count
    }
    
    //MARK:- Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ItemArray[indexPath.row].title!)
        
        ItemArray[indexPath.row].done = !ItemArray[indexPath.row].done
        saveItems()
       // tableView.reloadData()
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
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
                self.ItemArray.append(newItem)
               // self.defaults.setValue(self.ItemArray, forKey: "ToDoListArray")
            self.saveItems()
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
    func saveItems(){
         do{
            try context.save()
             }catch{
                print("Error loading Save Items: \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
       //let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
            
        do{
            ItemArray = try context.fetch(request)
        }catch{
            print("Error Loading: \(error)")
        }
    }
    
}
 //MARK: - Search bar Methods
extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        do{
//            ItemArray = try context.fetch(request)
//        }catch{
//            print("Error Loading: /(erro)")
//        }

        loadItems(with: request, predicate: predicate)
        tableView.reloadData()
        
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
