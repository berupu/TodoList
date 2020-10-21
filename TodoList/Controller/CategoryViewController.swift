//
//  CategoryViewController.swift
//  TodoList
//
//  Created by be RUPU on 17/10/20.
//  Copyright © 2020 be RUPU. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    //realm initialize
    
    let realm = try! Realm()
    var categories : Results<Category>?

//    var categories = [Category]()
    
    //coredata save location
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//        let indexPath = indexPath.row
//        categories.remove(at: indexPath)
//        save(category: categories)
        
        //MARK: - Realm delete
        
        if let deleteCategory = categories?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(deleteCategory)
                }
                
            }catch{
                    print("error deleteing \(error)")
            }
            
        }
        tableView.reloadData()
     
     
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: -  CoreData Save
    
//    func saveCategories(){
//
//        do {
//            try context.save()
//        }catch {
//            print("Error saving category\(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    //MARK: - Realm Save
    
    func save(category: Category ){
           
           do {
            try realm.write{
                realm.add(category)
            }
           }catch {
               print("Error saving category\(error)")
           }
           
           tableView.reloadData()
 
       }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        
        //MARK: - CoreData Loading Data
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do{
//            categories = try context.fetch(request)
//        }catch {
//            print("error loading categories \(error)")
//        }

        tableView.reloadData()
        
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //for coreData
            
//            let newCategory = Category(context: self.context)
            
            //for realm
                let newCategory = Category()

            newCategory.name = textField.text!
            

//            self.categories.append(newCategory)
            
            self.save(category: newCategory)
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
