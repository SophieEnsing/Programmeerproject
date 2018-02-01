//
//  AccountViewController.swift
//  FilmApp
//
//  This view controller shows the
//  account details of either the logged in user
//  or a selected user (from the friendlist for example)
//
//  Created by Sophie Ensing on 22-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UICollectionViewDataSource {
    // MARK: Properties
    var watchList = [Movie]()
    var recList = [Movie]()
    var movieList = [Movie]()
    var userID = Auth.auth().currentUser!.uid
    var currentUser: User!
    
    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameLabel: UILabel!

    // MARK: Actions
    @IBAction func addFriendAction(_ sender: Any) {
        addUser()
    }
    
    // Change the data in the collection view based on the selected segment.
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            movieList = watchList
            updateUI(with: movieList)
        case 1:
            movieList = recList
            updateUI(with: movieList)
        default:
            break
        }
    }
    
    // Sign out the current user and go to login.
    @IBAction func signOutAction(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    // MARK: Functions
    func addUser() {
        // Add user as a friend.
        let thisUser = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(thisUser).child("friends").child(currentUser.id)
        let userData: [String: Any] = ["username": currentUser.username]
        ref.setValue(userData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        // Check if the account is the current user or not and change text.
        if userID == Auth.auth().currentUser!.uid {
            friendButton.setTitle("This is you!", for: [])
            self.friendButton.isEnabled = false;
        } else {
            friendButton.setTitle("Add as friend", for: [])
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // Show username.
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.usernameLabel.text = username
        })
        
        // Get the users watchlist.
        ref.child("watchlist").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.watchList = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let title = movieObject!["title"]
                    let poster = movieObject!["poster"]
                    let overview = movieObject!["overview"]
                    let id = movieObject!["id"]
                    let movieToBeAdded = Movie(id: id! as! Int, title: title! as! String,
                                overview: overview! as! String, poster_path: poster as? String)
                    self.watchList.append(movieToBeAdded)
                }
                self.movieList = self.watchList
                self.updateUI(with: self.movieList)
            }
        })

        // Get the users recommended movies.
        ref.child("recs").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.recList = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let id = movieObject!["id"]
                    let title = movieObject!["title"]
                    let overview = movieObject!["overview"]
                    let poster = movieObject!["poster"]
                    let movieToBeAdded = Movie(id: id! as! Int, title: title! as! String,
                                               overview: overview! as! String, poster_path: poster as? String)
                    self.recList.append(movieToBeAdded)
                }
                self.movieList = self.recList
            }
        })

        // Add column layout to collectionview.
        collectionView?.collectionViewLayout = ColumnFlowLayout.columnLayout
    }

    
    func updateUI(with movieList: [Movie]) {
        DispatchQueue.main.async {
            self.movieList = movieList
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! CollectionViewCell

        let thisMovie = movieList[indexPath.row]
        cell.filmPoster.contentMode = .scaleAspectFill
        var completeURL = MovieController.completeURL

        if thisMovie.poster_path != nil {
            completeURL = MovieController.baseURL + String(describing: thisMovie.poster_path!)
        }

        cell.filmPoster.downloadedFrom(link: completeURL)
        return cell
    }
    
    // Segue to see movie details.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileMovieDetailsSegue" {
            if let destination = segue.destination as? MovieDetailsViewController {
                let cell = sender as! CollectionViewCell
                let indexPath = collectionView.indexPath(for: cell)
                let selectedCell = movieList[(indexPath?.row)!]
                destination.movie = selectedCell
            }
        }
    }
}

