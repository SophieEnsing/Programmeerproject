//
//  Movie.swift
//  FilmApp
//
//  Created by Sophie Ensing on 15-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var video: Bool
    var title: String
    var overview: String
    var vote_average: Double
    var vote_count: Int
    var popularity: Double
    var poster_path: URL? = nil
    var original_language: String
    var original_title: String
    var genre_ids: [Int]
    var backdrop_path: String? = nil
    var adult: Bool
    var release_date: String
}

struct Movies: Codable {
    let results: [Movie]
}
