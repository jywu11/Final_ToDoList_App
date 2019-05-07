//
//  SignUpViewController.swift
//  reFridge
//
//  Created by Jeremiah Wu on 2/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var signUpFirstNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpConfirmPasswordTextField: UITextField!
    
    
    @IBAction func createAccButton(_ sender: Any) {
        // Checks if all the fields have been filled out. If empty, show prompt.
        if signUpFirstNameTextField.text == "" || signUpEmailTextField.text == "" || signUpPasswordTextField.text == "" || signUpConfirmPasswordTextField.text == ""{
            displayMessage(title: "Field Was Left Blank", message: "Please make sure all the fields are filled.", id: "ok")
        
        }
            // Checks if all the fields have been filled out. If empty, show prompt.
        else if signUpPasswordTextField.text != signUpConfirmPasswordTextField.text {
            displayMessage(title: "Passwords Do Not Match", message: "Passwords do not match. Please try again.", id: "ok")
            
            
        }
            
            // If no errors, create the account in Firebase and store user's first name into UserDefaults.
        else{
            Auth.auth().createUser(withEmail: signUpEmailTextField.text!, password: signUpPasswordTextField.text!){ (user, error) in
                if error == nil {
                    let defaults = UserDefaults.standard
                    let firstName = self.signUpFirstNameTextField.text
                    defaults.set(firstName, forKey: "name")
                    self.performSegue(withIdentifier: "RegisterToHomeScreenSegue", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Function that helps display alert messages.
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
    
//     Function to minimize keyboard when the return key is pressed.
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
