//
//  recipeSearchViewController.swift
//  Final_ToDoList_App
//
//  Created by Rebecca Lim on 5/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class recipeSearchViewController: UIViewController, UITextFieldDelegate {
    var  ingredientsList:[String] = []
    var defaultText = "Ingredients List: \n"
    @IBOutlet weak var ingredientTextField: UITextField!
    
    @IBAction func addToListButton(_ sender: Any) {
        if ingredientTextField.text != ""{
            addButtonPressed()
        }
        else{
            displayMessage(title: "Field Was Left Blank", message: "Please enter a ingredient name.")
        }
    }

    @IBAction func clearListButton(_ sender: Any) {
        ingredientsList.removeAll()
        ingredientsListTextView.text = defaultText
    }
    @IBOutlet weak var ingredientsListTextView: UITextView!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func searchButton(_ sender: Any) {
        performSegue(withIdentifier: "searchToResultsSegue", sender: self)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTextField.delegate = self
        ingredientTextField.becomeFirstResponder()
        ingredientsListTextView.text = defaultText

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addButtonPressed()
        return true
    }
    
    func addButtonPressed(){
        let ingredientToAdd = ingredientTextField.text
        ingredientsList.append(ingredientToAdd ?? "empty")
        ingredientsListTextView.text = ingredientsListTextView.text + ingredientToAdd! + "\n"
        ingredientTextField.text = ""
    }
    
    func displayMessage(title: String, message: String, id:String?=nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if id == "ok"{
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        }
        else{
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
