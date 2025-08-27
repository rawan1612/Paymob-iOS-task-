//
//  MovieResponse.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
    let totalPages : Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
       
    }
}

struct Movie: Codable {
    let adult: Bool 
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    // Custom coding keys to match JSON snake_case
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
  
}
extension Movie {
    init(id: Int, title: String, posterPath: String?, releaseDate : String?, voteAverage: Double?, overview : String?) {
        self.adult = false
        self.backdropPath = nil
        self.genreIds = []
        self.id = id
        self.originalLanguage = ""
        self.originalTitle = ""
        self.overview = overview ?? ""
        self.popularity = 0
        self.posterPath = posterPath
        self.releaseDate = releaseDate ?? ""
        self.title = title
        self.video = false
        self.voteAverage = voteAverage ?? 0
        self.voteCount = 0
    }
}
