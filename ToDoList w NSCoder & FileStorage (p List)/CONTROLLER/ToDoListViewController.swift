//
//  ToDoListViewController.swift
//  ToDoList w NSCoder & FileStorage (p List)
//
//  Created by Rafael M. Trasmontero on 9/19/19.
//  Copyright © 2019 RMT. All rights reserved.
//
import UIKit

class TodoListViewController: UITableViewController {
    
    var itemsArray = [Item]()
    
    //*** CREATE FILEPATH FOR TO SAVE DATA in .Documentditrectory in the .userDomainMask ("default" Singleton Array) & name of folder "Items.plist". NOTE: We can have multiple of these folders/plists to load different things like options/settings etc.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*** TRACE & LOOK WHERE FILES ARE BEING WRITTEN
        print(dataFilePath!)

        loadItems()
    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        // VALUE = CHECK CONDITION ? USE IF TRUE : USE IF FALSE
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Toggle True/False
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        //De-Highlights selection
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        
    }
    
    //MARK: - Adding New Items via Alert & TextField
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Local reference
        var localTextField = UITextField()
        
        //Alert Popup
        let alert = UIAlertController.init(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = localTextField.text!
            self.itemsArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            localTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //*** SAVE OUR ITEM OBJECT TO PLIST BY ENCODING IT INTO DATA FIRST, THEN WRITING INTO OUR FILEPATH
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemsArray)
            try data.write(to:dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    //*** LOAD ITEMS FROM PLIST BY DECODING THE PLIST DATA INTO ITEM OBJECTS
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemsArray = try decoder.decode([Item].self, from: data)
            } catch {
            print(error.localizedDescription)
            }
        }
    }
    
    
}

