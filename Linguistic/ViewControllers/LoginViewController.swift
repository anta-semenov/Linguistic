//
//  LoginViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import Security
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load current user state from key chain
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn() {
        if checkFields() {
            PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: paswordTextField.text!)
        }
    }
    
    @IBAction func signUp() {
        if checkFields() {
            let newUser = PFUser()
            newUser.username = usernameTextField.text
            newUser.password = paswordTextField.text
        
            newUser.signUpInBackground()
        }
    }
    
    func checkFields() -> Bool {
        guard usernameTextField.text! != "" && paswordTextField.text! != "" else {
            showAlert("Empty requirements fields", message: "Fill username and password for log in")
            return false
        }
        return true
    }

}
