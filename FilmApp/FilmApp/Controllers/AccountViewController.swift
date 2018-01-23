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
    @IBOutlet weak var collectionView: UICollectionView!
    var movieList = [Movie]()
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 4,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        MovieController.shared.fetchMovies(baseURL: URL(string: "https://api.themoviedb.org/3/movie/popular?")!, queries: ["api_key":"15d0d9f81918875498b3c675e590ae34"]){ (movieList) in
            if let movieList = movieList {
                self.updateUI(with: movieList)
            }
        }
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

