//
//  AddTaskViewController.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu  on 15/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    weak var databaseController: DatabaseProtocol?
    var categorySelected = "Beverages"
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    
    // Data source for the pickerview, array of shopping list categories.
    
    private let categories = ["Beverages","Bread","Canned Goods","Dairy","Dry/Baking Goods","Frozen Foods", "Meat","Produce","Cleaners","Personal Care","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Styling for the form buttons. Make the corners rounded.
        createButton.layer.cornerRadius = 5.0
        createButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.masksToBounds = true
        
        self.nameTextField.delegate = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
    }
    
    
    
    // If the create button is tapped, call the add task button.
    @IBAction func createTapped(_ sender: Any) {
        
        if nameTextField.text != "" {
            let name = nameTextField.text!
            let category = categorySelected
            
            displayMessage(title: "Congratulations", message: "Your task was successfully added to the list.", id: "congrats")

            let _ = databaseController!.addTask(name: name, category: category)

            performSegue(withIdentifier: "addBackToTaskSegue", sender: self)

            
            return
        }
        
        var errorMsg = "Please ensure all fields are filled:\n"
        
        if nameTextField.text == "" {
            errorMsg += "- Must provide a task name\n"
        }
        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    // When the cancel button is tapped, pop view controller.
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Function to choose which alert message to display.
    func displayMessage(title: String, message: String, id:String?=nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        if id == "congrats"{
            alertController.addAction(okAction)
        }
        
        else{
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let value = categories[row]
        categorySelected = value
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
