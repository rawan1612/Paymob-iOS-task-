//
//  MockMoviesRepository.swift
//  paymobTaskTests
//
//  Created by Rawan Ashraf on 27/08/2025.
//

import Foundation
import Combine
@testable import paymobTask
import RealmSwift
@testable import paymobTask

final class MockMoviesRepository: MoviesRepositoryProtocol {
    
    var moviesDB: [MovieObject] = []
    
    // Return a Realm Results-like object
    func getMovies() -> Results<MovieObject> {
        // Convert array to a fake Results using Realm's List
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        try! realm.write {
            realm.add(moviesDB, update: .all)
        }
        return realm.objects(MovieObject.self)
    }
    
    func addOrUpdate(_ movie: MovieObject) {
        if let index = moviesDB.firstIndex(where: { $0.id == movie.id }) {
            moviesDB[index] = movie
        } else {
            moviesDB.append(movie)
        }
    }
    
    func removeFavorite(movieId: Int) {
        moviesDB.removeAll { $0.id == movieId }
    }
    
    func getMovie(by id: Int) -> MovieObject? {
        return moviesDB.first { $0.id == id }
    }
}
final class MockNetworkMonitor {
    var isConnected: Bool = true
}
