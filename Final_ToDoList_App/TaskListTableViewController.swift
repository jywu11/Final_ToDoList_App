//
//  TaskListTableViewController.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu  on 15/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController, DatabaseListener , UISearchResultsUpdating{
    
    let SECTION_TASKS = 0;
    let SECTION_COUNT = 1;
    let CELL_TASKS = "taskCell"
    let CELL_COUNT = "listSizeCell"
    
    weak var superHeroDelegate: AddTaskDelegate?
    weak var databaseController: DatabaseProtocol?
    
    var currentTasks: [ShoppingItem] = []
    var filteredTasks: [ShoppingItem] = []
    var  completedTasks: [ShoppingItem] = []
    let currentDate = Date()
    
    @IBOutlet weak var countLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        
        // Initialise the search controller, configure some settings and place it on the navigation item.
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.searchController = searchController
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Shopping List", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])



        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
    }
    
    // This will make sure the search bar is always visible, even when scrolling. Part 1.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            databaseController?.addListener(listener: self)
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    // This will make sure the search bar is always visible, even when scrolling. Part 2.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            databaseController?.removeListener(listener: self)
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    // DATABASE LISTENER:
    
    var listenerType = ListenerType.tasks
    
    func onTaskListChange(change: DatabaseChange, tasksFromDB: [ShoppingItem]) {
        filteredTasks.removeAll()
        tableView.reloadData()
        if tasksFromDB.count > 0 {
            for index in 0...tasksFromDB.count-1{
                filteredTasks.append(tasksFromDB[index])
                currentTasks = filteredTasks
                updateSearchResults(for: navigationItem.searchController!)
                tableView.reloadData();
            }
        }
    }
    
    // If there is something typed in the bar, the filtered array will equal to currentTasks array + search text filter
    // Else, filtered is the same as current.
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredTasks = currentTasks.filter({(task: ShoppingItem) -> Bool in
                return (task.name.lowercased().contains(searchText))
                //                return (task.completed == true)
                
            })
        }
        else {
            filteredTasks = currentTasks;
        }
        tableView.reloadData();
    }
    
    
    // TABLE VIEW DATA SOURCE
    
    // 2 sections, first is tasks, second is count.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    // If it is the tasks section, it will be a dynamic row count, based on the filtered array.
    // Else, we just need 1 row to display the count.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == SECTION_TASKS {
            return filteredTasks.count
        }
        else {
            return 1
        }
        
        
    }
    
    // Puts the data from array into the cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_TASKS {
            let currentTaskCell = tableView.dequeueReusableCell(withIdentifier: CELL_TASKS, for: indexPath)
                as! TaskTableViewCell
            
            let task = filteredTasks[indexPath.row]
            
            currentTaskCell.nameLabel.text = task.name
            currentTaskCell.categoryLabel.text = task.category
            
            return currentTaskCell
        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        countCell.textLabel?.text = "\(filteredTasks.count) Items In Your Shopping List."
        countCell.selectionStyle = .none
        countLabel.text = "\(filteredTasks.count) ITEMS."
        return countCell
    }
    
    
    // Function if user selects a row. Perform action.
    // If it a count section, do not select.
    // If it is a task section, bring up task detail for that particular task.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_COUNT {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        return
    }
    
    
    // Able to "edit" tasks. ie. delete
    // Unable to edit counter row.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_TASKS {
            return true
        }
        return false
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        let deleteTaskAction = UITableViewRowAction(style: .destructive, title: "DELETE") { action, index in
            if  (indexPath.section == self.SECTION_TASKS) {
                self.databaseController?.deleteTask(task: self.filteredTasks[indexPath.row])
                self.currentTasks.remove(at: indexPath.row)
                self.filteredTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                
            }
        }
        let completeTaskAction = UITableViewRowAction(style: .normal, title: "FRIDGE") { action, index in
            if  (indexPath.section == self.SECTION_TASKS) {
                let name = (self.filteredTasks[indexPath.row].name)
                let category = (self.filteredTasks[indexPath.row].category)
                
                self.databaseController?.editTask(name: name, newName: name, category: category)
                self.currentTasks.remove(at: indexPath.row)
                self.filteredTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
        deleteTaskAction.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.23, alpha:1.0)
        completeTaskAction.backgroundColor = UIColor(red:0.43, green:0.79, blue:0.28, alpha:1.0)
        return [completeTaskAction,deleteTaskAction]
    }
    
}
