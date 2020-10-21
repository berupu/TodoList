//
//  ViewController.swift
//  ToDoey
//
//  Created by be RUPU on 21/3/20.
//  Copyright © 2020 be RUPU. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift


class ToDoListViewController : UITableViewController {
        
    var itemArray : Results<Item>?
//    var itemArray = [Item]()
    let realm = try! Realm()
      //todoItems
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //MARK: -  initialing UserDefaults
   //let defaults = UserDefaults.standard
    
    //MARK: -  Initial path for FileManger(Where it will save)
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //MARK: -  CoreData storage loacation or connecting with persistentContainer
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: -  Data storage location for current app(Where the data store?)
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
        
         //MARK: -  loading data from UserDefaults
//        if let items = defaults.array(forKey: "TodoListArray")  as? [String]{
//            itemArray = items
//        }
        
        
          loadItems()

    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
     
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//        saveItems()
        
        
        //MARK: - Realm Update done status
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("error saving done status \(error)")
            }
            
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)


    }
    
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
       //MARK: - CoreData Delete
//        //Deleting data with coreData
////        context.delete(itemArray[indexPath.row])
////        //after deleting from CoreData we need to delete it from itemArray too.
////        itemArray.remove(at: indexPath.row)
////        //after deleting we need to save
////        saveItems()
//
//
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
            
            //MARK: -  declaring CoreData class or entity.
            
            
//            let newItem = Item(context: self.context)
//            newItem.title = textFiled.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
//
              //MARK: -  save by UserDefaults
//            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
//
//            self.saveItems()
            
            //MARK: - Realm save
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                   let newItem = Item()
                   newItem.title = textFiled.text!
                   currentCategory.items.append(newItem)
                }
                }catch {
                    print("error saving new item \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

//        let indexPath = indexPath.row
//        itemArray.remove(at: indexPath)
//        tableView.reloadData()
        
        
        //MARK: - Realm Delete
        
        if let item = itemArray?[indexPath.row] {
                  do {
                      try realm.write {
                        realm.delete(item)
                      }
                  }catch{
                      print("error saving done status \(error)")
                  }
                  
              }
              tableView.reloadData()

    }
    
    func saveItems(){
        
        //MARK: -  saving or encode data with FileManager
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error\(error)")
//        }
//        self.tableView.reloadData()
        
        
        
        
        //MARK: -  Saving data with CoreData
//        do{
//
//            try context.save()
//        } catch {
//
//            print("Error\(error)")
//        }
//
//        self.tableView.reloadData()
    }
    
    //MARK: - Realm loading data
    
    func loadItems(){
        
        //sorted by ascending
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
    
        //MARK: -  loading data or decodeing data by FileManager

//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//
//            } catch {
//                print("Error decoding ,\(error)")
//            }
//        }
        
        //MARK: - CoreData searching and sorting
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
        
        
        //MARK: -  Loding or Read data with CoreData
        
//        let request: NSFetchRequest = Item.fetchRequest()      //this line goes to parameter
//        do{
//            //fetching data from CoreData and then putting it in itemArray array.
//           itemArray = try context.fetch(request)
//
//        }catch {
//            print("Error loading CoreData ,\(error)")
//        }
//
//        tableView.reloadData()
//
//    }
          
}

extension ToDoListViewController : UISearchBarDelegate {
    
    //MARK: - searching/query and sorting with coreData
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //searching from request
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //now sorting
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        
//        loadItems(with: request, predicate: predicate)
//
//    }
    
    //MARK: - searching/query and sorting with Realm
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
              searchBar.resignFirstResponder()
            }
        }
    }
    
}
