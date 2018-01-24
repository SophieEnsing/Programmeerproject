//
//  FriendsViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 24-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var userList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid

        ref.child("users").child(userID).child("friends").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.userList = []
                for users in snapshot.children.allObjects as! [DataSnapshot] {
                    let userObject = users.value as? [String: String]
                    let username = userObject!["username"]
                    let id = users.key
                    let userToBeAdded = User(id: id, username: username!)
                    self.userList.append(userToBeAdded)
                }
                self.updateUI(with: self.userList)
            }
        })
    }
    
    func updateUI(with userList: [User]) {
        DispatchQueue.main.async {
            self.userList = userList
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! TableViewCell
        let thisUser = userList[indexPath.row]
        cell.userLabel.text = thisUser.username
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailsSegue" {
            if let destination = segue.destination as? AccountViewController {
                let cell = sender as! TableViewCell
                let indexPath = tableView.indexPath(for: cell)
                let selectedCell = userList[(indexPath?.row)!]
                destination.userID = selectedCell.id
            }
        }
    }
}
