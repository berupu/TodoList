//
//  ViewController.swift
//  ToDoey
//
//  Created by be RUPU on 21/3/20.
//  Copyright © 2020 be RUPU. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController : UITableViewController {

    var itemArray = [Item]()
    
    // initialing UserDefaults
   //let defaults = UserDefaults.standard
    
    //Initial path for FileManger(Where it will save)
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    // CoreData storage loacation or connecting with persistentContainer.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Data storage location for current app(Where the data store?)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
        
        //loading data from UserDefaults
//        if let items = defaults.array(forKey: "TodoListArray")  as? [String]{
//            itemArray = items
//        }
        
        
          loadItems()

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

        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)


    }
    
    
    //CoreData Delete
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //Deleting data with coreData
//        context.delete(itemArray[indexPath.row])
//        //after deleting from COreData we need to delete it from itemArray too.
//        itemArray.remove(at: indexPath.row)
//        //after deleting we need to save
//        saveItems()
//
//          tableView.deselectRow(at: indexPath, animated: true)
//
//
//      }
      
   
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            
            //normal class declaration for UserDefaults and NSCoder(FileManager)
//            let let newItem = Item()
            
            //declaring CoreData class or entity.
            let newItem = Item(context: self.context)
            newItem.title = textFiled.text!
            newItem.done = false
    
            self.itemArray.append(newItem)
            
            //save by UserDefaults
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
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
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error\(error)")
//        }
//        self.tableView.reloadData()
        
        
        
        
        //Saving data with CoreData
        do{
            
            try context.save()
        } catch {
            
            print("Error\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        //loading data or decodeing data by FileManager

//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//
//            } catch {
//                print("Error decoding ,\(error)")
//            }
//        }
        
        
        //Loding or Read data with CoreData
        
//        let request: NSFetchRequest = Item.fetchRequest()      //this line goes to parameter
        do{
            //fetching data from CoreData and then putting it in itemArray array.
           itemArray = try context.fetch(request)
        
        }catch {
            print("Error loading CoreData ,\(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //searching from request
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //now sorting
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request)
        
    }
    
}
