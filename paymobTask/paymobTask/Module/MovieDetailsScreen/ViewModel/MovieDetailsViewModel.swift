//
//  MovieDetailsViewModel.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 26/08/2025.
//

import Foundation
class MovieDetailsViewModel {
    @Published var isFav: Bool = false
    let movie: Movie
    
    private let repository: MoviesRepositoryProtocol
    private(set) var movieDB: MovieObject?
    
    init(movie: Movie , repository: MoviesRepositoryProtocol = MoviesRepository()) {
        self.movie = movie
        self.repository = repository
        // map response model to Realm model
        self.movieDB = MovieObject(from: movie)
        // if movie already exists in DB, sync the isFav state
            if let dbMovie = repository.getMovie(by: movie.id) {
                print("Object in database")
                self.movieDB = dbMovie
                self.isFav = true
            }
    }
    
    var title: String { movie.title }
    var description : String { movie.overview }
    var rating: String { "\(movie.voteAverage)" }
    var movieLang : String { movie.originalLanguage }
    var posterURL: URL? {
        guard let posterPath = movie.posterPath
        else { return nil }
        return URL(string: "\(Constants.BASE_IMAGE_URL)\(posterPath)")
        
    }
    func saveToFavorites() {
        guard let movieDB = movieDB else { return }
                repository.addOrUpdate(movieDB)
        if let updated = repository.getMovie(by: movieDB.id) {
            self.movieDB = updated
            self.isFav = true
        }
    }
    
    func removeMovieFromDB(){
        guard let movieDB = movieDB else { return }
        repository.removeFavorite(movieId: movieDB.id)
        self.isFav = false

    }
    
 

}
