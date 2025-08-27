//
//  MovieDetailsViewModelTest.swift
//  paymobTaskTests
//
//  Created by Rawan Ashraf on 27/08/2025.
//

import XCTest
@testable import paymobTask

final class MovieDetailsViewModelTests: XCTestCase {
    
    var viewModel: MovieDetailsViewModel!
    var repository: MockMoviesRepository!
    var sampleMovie: Movie!
    
    override func setUp() {
        super.setUp()
        repository = MockMoviesRepository()
        sampleMovie = Movie(
            adult: true,
            backdropPath: "/poster.jpg",
            genreIds: [],
            id: 1,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            overview: "overview ",
            popularity: 0,
            posterPath: "/poster.jpg",
            releaseDate: "27-8-2025",
            title: "Test Movie",
            video: false,
            voteAverage: 0.0,
            voteCount: 1000
        )
        viewModel = MovieDetailsViewModel(movie: sampleMovie, repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        viewModel = nil
        sampleMovie = nil
        super.tearDown()
    }
    
    // MARK: - Test initial state
    
    func testInitialState_NotFavorite() {
        XCTAssertFalse(viewModel.isFav)
        XCTAssertEqual(viewModel.title, sampleMovie.title)
        XCTAssertEqual(viewModel.description, sampleMovie.overview)
        XCTAssertEqual(viewModel.rating, "\(sampleMovie.voteAverage)")
    }
    
    // MARK: - Test saving to favorites
    
    func testSaveToFavorites_AddsMovie() {
        XCTAssertFalse(viewModel.isFav)
        viewModel.saveToFavorites()
        XCTAssertTrue(viewModel.isFav)
        XCTAssertEqual(repository.moviesDB.count, 1)
        XCTAssertEqual(repository.moviesDB.first?.id, sampleMovie.id)
    }
    
    // MARK: - Test removing from favorites
    
    func testRemoveMovieFromDB_RemovesMovie() {
        // First add to favorites
        viewModel.saveToFavorites()
        XCTAssertTrue(viewModel.isFav)
        
        // Remove
        viewModel.removeMovieFromDB()
        XCTAssertFalse(viewModel.isFav)
        XCTAssertTrue(repository.moviesDB.isEmpty)
    }
    
    // MARK: - Test favorite state when movie exists in DB
    
    func testInitWithExistingMovie_SetsIsFavTrue() {
        // Pre-add movie in repository
        repository.addOrUpdate(MovieObject(from: sampleMovie))
        
        let vm = MovieDetailsViewModel(movie: sampleMovie, repository: repository)
        XCTAssertTrue(vm.isFav)
    }
}
