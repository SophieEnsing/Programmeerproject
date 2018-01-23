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
    
    @IBAction func watchlistAction(_ sender: Any) {
        addMovie()
    }
    
    func addMovie() {
        let userID = Auth.auth().currentUser!.uid
        let ref: DatabaseReference! = Database.database().reference().child("watchList").child(userID)
        let userData: [String: Any] = ["poster": String(describing: movie.poster_path),
                                       "overview": movie.overview,
                                       "title": movie.title]
        ref.child(String(movie.id)).setValue(userData)
    }

    var movie: Movie!
    let baseURL = "https://image.tmdb.org/t/p/w300"
    var completeURL = "https://i.imgur.com/69nFCBj.jpg"
    
    func updateUI() {
        movieTitle.text = movie.title
        moviePlot.text = movie.overview
        if movie.poster_path != nil {
            completeURL = baseURL + String(describing: movie.poster_path!)
        }
        moviePoster.downloadedFrom(link: completeURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
