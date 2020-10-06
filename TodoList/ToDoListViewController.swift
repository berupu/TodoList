//
//  ViewController.swift
//  ToDoey
//
//  Created by be RUPU on 21/3/20.
//  Copyright © 2020 be RUPU. All rights reserved.
//

import UIKit

class ToDoListViewController : UITableViewController {

    var itemArray = [Item]()
    
    // initialing UserDefaults
//    let defaults = UserDefaults.standard
    
    //Initial path for FileManger(Where it will save)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
        
        //loading data from UserDefaults
//        if let items = defaults.array(forKey: "TodoListArray")  as? [String]{
//            itemArray = items
//        }

    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
   
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textFiled.text!
            
            self.itemArray.append(newItem)
            
            //save by UserDefaults
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            //saving data with FileManager
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let indexPath = indexPath.row
        itemArray.remove(at: indexPath)
        tableView.reloadData()
        
    }
    
    func saveItems(){
        
        //saving or encode data with FileManager
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(){
        //loading data or decodeing data by FileManager
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
        
            } catch {
                print("Error decoding ,\(error)")
            }
        }
    }
    
    
}

