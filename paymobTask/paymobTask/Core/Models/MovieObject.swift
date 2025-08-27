//
//  MovieObject.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 26/08/2025.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var rating: String
    @Persisted var releaseYear: String
    @Persisted var overview: String
    @Persisted var posterURL: String
}
extension MovieObject {
    convenience init(from response: Movie) {
        self.init()
        self.id = response.id
        self.title = response.title
        self.overview = response.overview
        self.rating = "\(response.voteAverage)"
        self.releaseYear = response.releaseDate
        self.posterURL = "https://image.tmdb.org/t/p/w500\(response.posterPath ?? "")"

    }
}
