//
//  MovieDetailsViewController.swift
//  FilmApp
//
//  This view controller shows a selected movie
//  with the plot. It's possible here to add
//  a film to a watchlist or recommend it to a friend.
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
    
    // MARK: Outlets
    @IBOutlet weak var filmPoster: PosterImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var watchlistLabel: UILabel!
    @IBOutlet weak var recommendedLabel: UILabel!
    
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
                print(error!)
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
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID)
        super.viewDidLoad()
        updateUI()
        
        // Check if the movie is on the users watchlist and edit label.
        ref.child("watchlist").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                var watchList: [String] = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let title = movieObject!["title"]
                    watchList.append(title as! String)
                }
                if watchList.contains(self.movie.title) {
                    self.watchlistButton.isSelected = true
                    self.watchlistLabel.text = "Remove from watchlist"
                }
            }
        })
        
        // Check if the movie was recommended to the logged user.
        ref.child("recs").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                var recList: [String] = []
                for movies in snapshot.children.allObjects as! [DataSnapshot] {
                    let movieObject = movies.value as? [String: AnyObject]
                    let title = movieObject!["title"]
                    let user = movieObject!["by"]
                    recList.append(title as! String)
                    
                    // If the movie was recommended, display which user recommended it.
                    if recList.contains(self.movie.title) {
                        let userRef = Database.database().reference().child("users").child(user as! String)
                        
                        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let username = value?["username"] as? String ?? ""
                            self.recommendedLabel.text = "\(username) recommended this movie to you."
                        })
                    }
                }
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
