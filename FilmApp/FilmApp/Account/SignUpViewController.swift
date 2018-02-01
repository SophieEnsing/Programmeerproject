//
//  SignUpViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 15-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Actions
    @IBAction func signUpPressed(_ sender: AnyObject) {
        // Check if the email and password fields are not empty.
        if emailField.text == "" || usernameField.text == ""{
            // Alert the user when error occurs.
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            // Authorise user.
            Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                        
                    if error == nil {
                        // Create user in database.
                        let userID = Auth.auth().currentUser!.uid
                        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID)
                        let userData: [String: Any] = ["username": self.usernameField.text!]
                        ref.setValue(userData)

                        // Send user to HomeScreen
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen")
                        self.present(vc!, animated: true, completion: nil)
                        
                    } else {
                        // Alert the user when error occurs.
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
