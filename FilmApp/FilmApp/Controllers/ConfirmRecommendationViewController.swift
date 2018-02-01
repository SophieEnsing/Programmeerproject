//
//  ConfirmRecommendationViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 25-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class ConfirmRecommendationViewController: UIViewController {
    // MARK: Properties
    var movie: Movie!
    var user: User!
    
    // MARK: Outlets
    @IBOutlet weak var filmPoster: PosterImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: Actions
    @IBAction func confirmPressed(_ sender: Any) {
        addMovie()
    }

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func addMovie() {
        // Add movie to recommended movies to the selected user.
        let thisUser = Auth.auth().currentUser!.uid
        let userID = user.id
        let ref: DatabaseReference! = Database.database().reference().child("users")
                                            .child(userID).child("recs")
        let userData: [String: Any] = ["id": self.movie.id,
                                       "poster": self.movie.poster_path!,
                                       "overview": self.movie.overview,
                                       "title": self.movie.title,
                                       "by": thisUser]
        ref.child(String(self.movie.id)).setValue(userData)
    }
    
    var completeURL = MovieController.completeURL
    
    func updateUI() {
        textLabel.text = "Recommend \(movie.title) to \(user.username)?"
        if movie.poster_path != nil {
            completeURL = MovieController.baseURL + String(describing: movie.poster_path!)
        }
        filmPoster.downloadedFrom(link: completeURL)
    }
    
    // Go back to the movie details after confirmation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMovieSegue" {
            if let destination = segue.destination as? MovieDetailsViewController {
                destination.movie = movie
            }
        }
    }
}
