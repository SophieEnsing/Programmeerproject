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

//    let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie?")!
    let query2: [String: String] = ["api_key":"15d0d9f81918875498b3c675e590ae34",
                                   "query":"the avengers"]

    let baseURL = URL(string: "https://api.themoviedb.org/3/movie/popular?")!
    let baseURL2 = URL(string: "https://api.themoviedb.org/3/search/movie?")!
    let query: [String: String] = ["api_key":"15d0d9f81918875498b3c675e590ae34"]
    
    func fetchMovies(completion: @escaping ([Movie]?) -> Void) {
        let movieURL2 = baseURL2.withQueries(query2)!
        
        let task = URLSession.shared.dataTask(with: movieURL2) {(data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            
            do {
                let movies = try jsonDecoder.decode(Movies.self, from: data!)
                completion(movies.results)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}
