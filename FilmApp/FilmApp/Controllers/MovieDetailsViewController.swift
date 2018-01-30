//
//  MovieDetailsViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 19-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var watchlistLabel: UILabel!
    @IBAction func watchlistAction(_ sender: Any) {
        if watchlistButton.isSelected == true {
            removeMovie()
        } else {
            addMovie()
        }
        
        watchlistButton.isSelected = !watchlistButton.isSelected
        
    }

    func removeMovie() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("watchlist")
        ref.child(String(describing: movie.id)).removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                print("Child Removed Correctly")
            }
        })
        self.watchlistLabel.text = "Add to watchlist"
    }
    
    func addMovie() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("watchlist")
        let userData: [String: Any] = ["id": self.movie.id,
                                        "poster": self.movie.poster_path!,
                                        "overview": self.movie.overview,
                                        "title": self.movie.title]
        ref.child(String(self.movie.id)).setValue(userData)
        self.watchlistLabel.text = "Remove from watchlist"
    }
    
    var movie: Movie!
    let baseURL = "https://image.tmdb.org/t/p/w300"
    var completeURL = "https://i.imgur.com/69nFCBj.jpg"
    var watchList: [String] = []
    
    func updateUI() {
        movieTitle.text = movie.title
        moviePlot.text = movie.overview
        if movie.poster_path != nil {
            completeURL = baseURL + String(describing: movie.poster_path!)
        }
        moviePoster.downloadedFrom(link: completeURL)
    }
    
    override func viewDidLoad() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("watchlist")
        super.viewDidLoad()
        updateUI()
        ref.observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.watchList = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let title = movieObject!["title"]
                    self.watchList.append(title as! String)
                }
            }
            if self.watchList.contains(self.movie.title) {
                self.watchlistButton.isSelected = true
                self.watchlistLabel.text = "Remove from watchlist"
            }
        })
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecommendSegue" {
            if let destination = segue.destination as? RecommendViewController {
                destination.movie = movie
            }
        }
    }
}
