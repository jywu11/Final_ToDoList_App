//
//  AddFridgeItemViewController.swift
//  Final_ToDoList_App
//
//  Created by Rebecca Lim on 6/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddFridgeItemViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBAction func uploadImageButton(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var expiryDatePicker: UIDatePicker!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var fridgeLocation: UIPickerView!

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // Data source for the pickerview, array of Fridge Locations
    private let locations = ["Fridge","Freezer","Pantry"]
    var locationSelected = "Fridge"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fridgeLocation.delegate = self
        self.fridgeLocation.dataSource = self
    }
    
    @IBAction func addToFridgeButton(_ sender: Any) {
        
        if itemNameTextField.text == "" {
            displayMessage(title: "Please Enter An Item Name", message: "Your Item Name Field Was Left Blank.")
            
        }
        else{
        let itemName = itemNameTextField.text
        let qty = quantityLabel.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-MMM-yyyy"
        let dateToString = dateFormatter.string(from: expiryDatePicker!.date)
        let expiry = dateToString
        let randomID = randomString(length: 8)
        let ref = Database.database().reference()
        
        ref.child("jeremiah_user/fridge/" + randomID).setValue(["name":itemName,"expiry":expiry,"quantity":qty,"location":locationSelected])
        
        displayMessage(title: "Congratulations", message: "Your item was successfully added to your fridge.", id: "congrats")
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let value = locations[row]
        locationSelected = value
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
