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
    static let baseURL = "https://image.tmdb.org/t/p/w300"
    static var completeURL = "https://i.imgur.com/69nFCBj.jpg"
    
    func fetchMovies(baseURL: URL, queries: [String: String], completion: @escaping ([Movie]?) -> Void) {
        let movieURL = baseURL.withQueries(queries)!
        
        let task = URLSession.shared.dataTask(with: movieURL) {(data, response, error) in
            let jsonDecoder = JSONDecoder()

            do {
                let movies = try jsonDecoder.decode(Movies.self, from: data!)
                completion(movies.results)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}
