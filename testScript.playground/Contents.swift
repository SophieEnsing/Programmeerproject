//: Playground - noun: a place where people can play

import UIKit
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

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

func fetchMovies(baseURL: URL, queries: [String: String], completion: @escaping ([Movie]?) -> Void) {
    let movieURL = baseURL.withQueries(queries)!
    
    let task = URLSession.shared.dataTask(with: movieURL) {(data, response, error) in
        let jsonDecoder = JSONDecoder()
        let movies = try jsonDecoder.decode(Movies.self, from: data!)
        completion(movies.results)
        print(movies.results)
    }
}

fetchMovies(baseURL: URL(string: "https://api.themoviedb.org/3/movie/popular?")!, queries: ["api_key":"15d0d9f81918875498b3c675e590ae34"]){ (movieList) in
    if let movieList = movieList {
        print("hoi")
    }
}
