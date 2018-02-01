//
//  MovieCollectionViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 15-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

class MovieViewController: UIViewController, UICollectionViewDataSource {
    // MARK: Properties
    var movieList = [Movie]()
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        // = MyDataSource(withMovieList: movieList)
        
        // Fetch all popular movies from API.
        MovieController.shared.fetchMovies(baseURL: URL(string: "https://api.themoviedb.org/3/movie/popular?")!, queries: ["api_key":"15d0d9f81918875498b3c675e590ae34"]){ (movieList) in
            if let movieList = movieList {
                self.updateUI(with: movieList)
            }
        }
        // Add column layout to collectionview.
        collectionView?.collectionViewLayout = ColumnFlowLayout.columnLayout
        self.navigationItem.setHidesBackButton(true, animated:true);
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
        var completeURL = MovieController.completeURL
        if thisMovie.poster_path != nil {
            completeURL = MovieController.baseURL + String(describing: thisMovie.poster_path!)
        }
        
        cell.filmPoster.downloadedFrom(link: completeURL)
        return cell
    }
    
    // Segue to see movie details.
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
