//
//  Movie.swift
//  FilmApp
//
//  Struct to load in movie data from
//  the movie database API.
//
//  Created by Sophie Ensing on 15-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var overview: String
    var poster_path: String? = nil
}

struct Movies: Codable {
    let results: [Movie]
}
