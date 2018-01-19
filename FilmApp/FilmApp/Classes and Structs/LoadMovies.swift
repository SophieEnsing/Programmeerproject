//
//  LoadMovieViewController.swift
//  FilmApp
//
//  Created by Sophie Ensing on 15-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

class MovieController {
    static let shared = MovieController()
    let baseURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key")!
    let query: [String: String] = ["api_key": "15d0d9f81918875498b3c675e590ae34"]

    func fetchMovies(completion: @escaping ([Movie]?) -> Void) {
        let movieURL = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: movieURL) {(data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let movies = try? jsonDecoder.decode(Movies.self, from: data) {
                completion(movies.results)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
