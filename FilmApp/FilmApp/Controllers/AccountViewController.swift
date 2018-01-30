//
//  AccountViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 22-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func addFriendAction(_ sender: Any) {
        addUser()
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
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
    var watchList = [Movie]()
    var recList = [Movie]()
    var movieList = [Movie]()
    var userID = Auth.auth().currentUser!.uid
    var currentUser: User!

    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    func addUser() {
        let thisUser = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(thisUser).child("friends").child(currentUser.id)
        let userData: [String: Any] = ["username": currentUser.username]
        ref.setValue(userData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        if userID == Auth.auth().currentUser!.uid {
            friendButton.setTitle("This is you!", for: [])
            self.friendButton.isEnabled = false;
        } else {
            friendButton.setTitle("Add as friend", for: [])
            self.navigationItem.rightBarButtonItem = nil
        }
        
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.usernameLabel.text = username
        })
        
        ref.child("watchlist").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.watchList = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let id = movieObject!["id"]
                    let title = movieObject!["title"]
                    let overview = movieObject!["overview"]
                    let poster = movieObject!["poster"]
                    let movieToBeAdded = Movie(id: id! as! Int, title: title! as! String,
                                overview: overview! as! String, poster_path: poster as? String)
                    self.watchList.append(movieToBeAdded)
                }
                self.movieList = self.watchList
                self.updateUI(with: self.movieList)
            }
        })
        
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
        
        collectionView?.collectionViewLayout = columnLayout
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
        
        let baseURL = "https://image.tmdb.org/t/p/w300"
        var completeURL = "https://i.imgur.com/69nFCBj.jpg"
        
        if thisMovie.poster_path != nil {
            completeURL = baseURL + String(describing: thisMovie.poster_path!)
        }
        
        cell.filmPoster.downloadedFrom(link: completeURL)
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailsSegue" {
            if let destination = segue.destination as? MovieDetailsViewController {
                let cell = sender as! CollectionViewCell
                let indexPath = collectionView.indexPath(for: cell)
                let selectedCell = movieList[(indexPath?.row)!]
                destination.movie = selectedCell
            }
        }
    }
}

