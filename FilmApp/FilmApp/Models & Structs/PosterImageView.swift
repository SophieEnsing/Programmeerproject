//
//  PosterImageView.swift
//  FilmApp
//
//  This subclass for imageviews add functions to
//  download images from the API.
//
//  Created by Sophie Ensing on 01-02-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit

class PosterImageView: UIImageView {
    // MARK: Functions
    // Makes it possible to get movie posters from the API and show them in the App.
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
