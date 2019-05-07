//
//  HomeScreenViewController.swift
//  reFridge
//
//  Created by Jeremiah Wu on 2/5/19.
//  Copyright © 2019 Monash University. All rights reserved.


import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController,UISearchBarDelegate,UITextFieldDelegate {



    @IBOutlet weak var searchRecipeButton: UIButton!
    @IBAction func homeToRecipeButton(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToSearchSegue", sender: self)
    }
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        //
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    let firstName = UserDefaults.standard.string(forKey: "name") ?? ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchRecipeButton.layer.cornerRadius = 5.0
        searchRecipeButton.layer.masksToBounds = true
        searchRecipeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        if firstName.count == 0 {
            welcomeLabel.text = "Welcome back, We've Missed You."
        }
        else{
            welcomeLabel.text = "Welcome back, " + firstName + "."
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //     Function to minimize keyboard when the return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
