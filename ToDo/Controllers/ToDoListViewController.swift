//
//  ViewController.swift
//  ToDo
//
//  Created by Abuzar Manzoor on 04/04/2018.
//  Copyright © 2018 AbuzarManzoor. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //let defaults = UserDefaults.standard
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var ItemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        
        loadItems()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mark - tableView data source
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
    
    //Mark - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ItemArray[indexPath.row].title)
        
        ItemArray[indexPath.row].done = !ItemArray[indexPath.row].done
        saveItems()
       // tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Item" , message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicked add button items
           
            let newItem = Item()
            newItem.title = textField.text!
            
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
    //Mark - Model Manupulation method
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(ItemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            ItemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error \(error)")
            }
            
            
        }
        
    }
    
}

