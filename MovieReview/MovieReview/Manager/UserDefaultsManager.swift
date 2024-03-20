//
//  UserDefaultsManager.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func getMovies() -> [Movie]
    func addMovie(_ newValue: Movie)
    func removeMovie(_ movie: Movie)
}

struct UserDefaultsManager: UserDefaultsManagerProtocol {
    let shared = UserDefaults.standard
    
    enum Key: String {
        case movie
    }
    
    func getMovies() -> [Movie] {
        guard let data = shared.data(forKey: Key.movie.rawValue) else { return [] }
        return (try? PropertyListDecoder().decode([Movie].self, from: data)) ?? []
    }
    
    func addMovie(_ newValue: Movie) {
        var movies = getMovies()
        movies.insert(newValue, at: 0)
        saveMovie(movies)
    }
    
    func removeMovie(_ movie: Movie) {
        var movies = getMovies()
        movies = movies.filter { $0.trimmedTitle != movie.trimmedTitle}
        saveMovie(movies)
    }
    
    private func saveMovie(_ newValue: [Movie]) {
        shared.set(
            try? PropertyListEncoder().encode(newValue),
            forKey: Key.movie.rawValue
        )
    }
}
