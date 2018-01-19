//
//  MovieCollectionViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 15-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class MovieViewController: UIViewController, UICollectionViewDataSource {

    var movieList = [Movie]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        MovieController.shared.fetchMovies{ (movieList) in
            if let movieList = movieList {
                self.updateUI(with: movieList)
            }
        }
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
        cell.filmTitle.text = thisMovie.title
        cell.filmPoster.contentMode = .scaleAspectFill
        
        let baseURL = "https://image.tmdb.org/t/p/w300"
        let completeURL = baseURL + String(describing: thisMovie.poster_path)
        
        cell.filmPoster.downloadedFrom(link: completeURL)
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "MovieDetailSegue" {
//            let movieItemDetailViewController = segue.destination as! MovieDetailViewController
//            let index = tableView.indexPathForSelectedRow!.row
//            movieItemDetailViewController.movieItem = movieItems[index]
//        }
//    }
    
}