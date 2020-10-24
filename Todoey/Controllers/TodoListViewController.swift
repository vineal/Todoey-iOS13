//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var itemArray: [Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        loadItems()
        
        
        //        if let listArry = userDefaults.array(forKey: "todoItemArray") as? [Item]{
        //            itemArray = listArry
        //        }
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        
        cell?.accessoryType = item.done ? .checkmark : .none
        
        cell?.textLabel?.text = item.title
        return cell!
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Item", message: "", preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        let negativeAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addTextField { (addItemTextField) in
            addItemTextField.placeholder = "Create a new item"
            textField = addItemTextField
        }
        alert.addAction(positiveAction)
        alert.addAction(negativeAction)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manupulation Methods
    func saveItems() {
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
}
