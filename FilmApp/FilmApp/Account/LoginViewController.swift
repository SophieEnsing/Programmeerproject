//
//  LoginViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 12-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Actions
    @IBAction func loginPressed(_ sender: AnyObject) {
        // Check if the email and password fields are not empty.
        if self.emailField.text == "" || self.passwordField.text == "" {
            // Alert the user when error occurs.
            let alertController = UIAlertController(title: "Error",
                    message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            // Authorise user and send to HomeScreen.
            Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                
                // Login succesful.
                if error == nil {
                    print("You have successfully logged in")
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
