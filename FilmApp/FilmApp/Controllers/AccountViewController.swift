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
    var movieList = [Movie]()
    var userID = Auth.auth().currentUser!.uid

    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.usernameLabel.text = username
        })
        
        ref.child("watchlist").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.movieList = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let id = movieObject!["id"]
                    let title = movieObject!["title"]
                    let overview = movieObject!["overview"]
                    let poster = movieObject!["poster"]
                    let movieToBeAdded = Movie(id: id! as! Int, title: title! as! String,
                                overview: overview! as! String, poster_path: poster as? String)
                    self.movieList.append(movieToBeAdded)
                }
                self.updateUI(with: self.movieList)
            }
        })
        collectionView?.collectionViewLayout = columnLayout
    }
    
    func updateUI(with movieList: [Movie]) {
        DispatchQueue.main.async {
            self.movieList = movieList
            self.collectionView.reloadData()
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

