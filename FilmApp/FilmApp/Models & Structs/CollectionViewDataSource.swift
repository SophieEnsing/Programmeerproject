//
//  CollectionViewDataSource.swift
//  FilmApp
//
//  Created by Sophie Ensing on 01-02-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var movieList = [Movie]()
    
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
}
