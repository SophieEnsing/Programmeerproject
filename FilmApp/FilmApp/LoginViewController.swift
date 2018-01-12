//
//  LoginViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 12-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func loginPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen")
        self.present(vc!, animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
