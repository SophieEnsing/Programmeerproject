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
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction func confirmPressed(_ sender: Any) {
        addMovie()
    }
    
    var movie: Movie!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func addMovie() {
        let thisUser = Auth.auth().currentUser!.uid
        let userID = user.id
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID).child("recs")
        let userData: [String: Any] = ["id": self.movie.id,
                                       "poster": self.movie.poster_path!,
                                       "overview": self.movie.overview,
                                       "title": self.movie.title,
                                       "by": thisUser]
        ref.child(String(self.movie.id)).setValue(userData)
    }
    
    let baseURL = "https://image.tmdb.org/t/p/w300"
    var completeURL = "https://i.imgur.com/69nFCBj.jpg"
    
    func updateUI() {
        textLabel.text = "Recommend \(movie.title) to \(user.username)?"
        if movie.poster_path != nil {
            completeURL = baseURL + String(describing: movie.poster_path!)
        }
        moviePoster.downloadedFrom(link: completeURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMovieSegue" {
            if let destination = segue.destination as? MovieDetailsViewController {
                destination.movie = movie
            }
        }
    }
}
