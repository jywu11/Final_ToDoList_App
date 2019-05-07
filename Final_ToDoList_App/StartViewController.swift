//
//  StartViewController.swift
//  reFridge
//
//  Created by Jeremiah Wu on 2/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
        }
    }
    
}
