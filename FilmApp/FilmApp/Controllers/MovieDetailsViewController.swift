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
    // MARK: Properties
    var movie: Movie!
    var completeURL = MovieController.completeURL
    var watchList: [String] = []
    
    // MARK: Outlets
    @IBOutlet weak var filmPoster: PosterImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var watchlistLabel: UILabel!
    
    // MARK: Actions
    @IBAction func watchlistAction(_ sender: Any) {
        // If the movie is on the watchlist, it can be removed, else it can be added.
        if watchlistButton.isSelected == true {
            removeMovie()
        } else {
            addMovie()
        }
        watchlistButton.isSelected = !watchlistButton.isSelected
    }

    // MARK: Functions
    // Remove movie from watchlist
    func removeMovie() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("watchlist")
        ref.child(String(describing: movie.id)).removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
            }
        })
        // Update watchlist label.
        self.watchlistLabel.text = "Add to watchlist"
    }

    // Add movie to watchlist
    func addMovie() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("watchlist")
        let userData: [String: Any] = ["id": self.movie.id,
                                        "poster": self.movie.poster_path!,
                                        "overview": self.movie.overview,
                                        "title": self.movie.title]
        ref.child(String(self.movie.id)).setValue(userData)
        // Update watchlist label.
        self.watchlistLabel.text = "Remove from watchlist"
    }
    

    
    func updateUI() {
        movieTitle.text = movie.title
        moviePlot.text = movie.overview
        if movie.poster_path != nil {
            completeURL = MovieController.baseURL + String(describing: movie.poster_path!)
        }
        filmPoster.downloadedFrom(link: completeURL)
    }
    
    override func viewDidLoad() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("watchlist")
        super.viewDidLoad()
        updateUI()
        
        // Check if the movie is on the users watchlist and edit label.
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

    // Recommend segue to recommend this movie to user.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecommendSegue" {
            if let destination = segue.destination as? RecommendViewController {
                destination.movie = movie
            }
        }
    }
}
