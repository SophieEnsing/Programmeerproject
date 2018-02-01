//
//  SearchViewController.swift
//  FilmApp
//
//  The goal of this controller is to search for
//  movies using the movie database API.
//
//  Created by Sophie Ensing on 22-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    // MARK: Properties
    var movieList = [Movie]()
    var searchQueries = ["api_key":"15d0d9f81918875498b3c675e590ae34", "query":""]
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        // Get text from search bar to query the API.
        let query = searchBar.text!
        searchQueries = ["api_key": "15d0d9f81918875498b3c675e590ae34", "query": query]
        collectionView.dataSource = self
        
        // Get data from API based on the search bar query.
        MovieController.shared.fetchMovies(baseURL: URL(string: "https://api.themoviedb.org/3/search/movie?")!, queries: searchQueries){ (movieList) in
            if let movieList = movieList {
                self.updateUI(with: movieList)
            }
        }
        // Add column layout to collectionview.
        collectionView?.collectionViewLayout = ColumnFlowLayout.columnLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    func updateUI(with movieList: [Movie]) {
        DispatchQueue.main.async {
            self.movieList = movieList
            self.collectionView.reloadData()
        }
    }
    
    // Number of cells are based on the number of movies to display.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }

    // Download all movieposters and display them in the collectionviewcells.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! CollectionViewCell
        let thisMovie = movieList[indexPath.row]
        cell.filmPoster.contentMode = .scaleAspectFill
        var completeURL = MovieController.completeURL
        
        // If there's no poster available, use defaultimage.
        if thisMovie.poster_path != nil {
            completeURL = MovieController.baseURL + String(describing: thisMovie.poster_path!)
        }

        cell.filmPoster.downloadedFrom(link: completeURL)
        return cell
    }
    
    // Segue to see movie details.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchMovieDetailsSegue" {
            if let destination = segue.destination as? MovieDetailsViewController {
                let cell = sender as! CollectionViewCell
                let indexPath = collectionView.indexPath(for: cell)
                let selectedCell = movieList[(indexPath?.row)!]
                destination.movie = selectedCell
            }
        }
    }
}

