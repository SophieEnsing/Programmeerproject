//
//  RecommendViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 24-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class RecommendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var friendList = [User]()
    var movie: Movie!
    
    let baseURL = "https://image.tmdb.org/t/p/w300"
    var completeURL = "https://i.imgur.com/69nFCBj.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        ref.child("users").child(userID).child("friends").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.friendList = []
                for users in snapshot.children.allObjects as! [DataSnapshot] {
                    let userObject = users.value as? [String: String]
                    let username = userObject!["username"]
                    let id = users.key
                    let userToBeAdded = User(id: id, username: username!)
                    self.friendList.append(userToBeAdded)
                }
                self.updateUI(with: self.friendList)
            }
        })
    }
    
    func updateUI(with friendList: [User]) {
        movieTitle.text = movie.title
        DispatchQueue.main.async {
            self.friendList = friendList
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! TableViewCell
        let thisUser = friendList[indexPath.row]
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
        if segue.identifier == "confirmRecommendation" {
            if let destination = segue.destination as? ConfirmRecommendationViewController {
                let cell = sender as! TableViewCell
                let indexPath = tableView.indexPath(for: cell)
                let selectedCell = friendList[(indexPath?.row)!]
                destination.user = selectedCell
                destination.movie = movie
            }
        }
    }
}
