//
//  MoviesRepository.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 26/08/2025.
//

import Foundation
import RealmSwift

protocol MoviesRepositoryProtocol {
    func getMovies() -> Results<MovieObject>
    func addOrUpdate(_ movie: MovieObject)
    func removeFavorite(movieId: Int)
    func getMovie(by id: Int) -> MovieObject?
}

class MoviesRepository: MoviesRepositoryProtocol {
    private let realm = RealmManager.shared.getRealm()
    
    func getMovies() -> Results<MovieObject> {
        return realm.objects(MovieObject.self)
    }
    
    func addOrUpdate(_ movie: MovieObject) {
        try! realm.write {
            realm.add(movie, update: .modified)
        }
    }
    func removeFavorite(movieId: Int) {
        if let movie = realm.object(ofType: MovieObject.self, forPrimaryKey: movieId) {
            try! realm.write {
                realm.delete(movie)
            }
        }
    }
    
   
    func isFavorite(movieId: Int) -> Bool {
        return realm.object(ofType: MovieObject.self, forPrimaryKey: movieId) != nil
    }
    
    func getMovie(by id: Int) -> MovieObject? {
        return realm.object(ofType: MovieObject.self, forPrimaryKey: id)
    }
}
