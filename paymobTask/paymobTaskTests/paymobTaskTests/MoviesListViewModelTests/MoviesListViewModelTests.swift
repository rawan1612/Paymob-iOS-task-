//
//  MoviesListViewModelTests.swift
//  paymobTaskTests
//
//  Created by Rawan Ashraf on 27/08/2025.
//

import XCTest
import Combine
@testable import paymobTask

final class MoviesListViewModelTests: XCTestCase {
    
    var viewModel: MoviesListViewModel!
    var repository: MockMoviesRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        repository = MockMoviesRepository()
        viewModel = MoviesListViewModel(repository: repository)
        cancellables = []
    }
    
    override func tearDown() {
        repository = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Favorite Logic
    
    func testToggleFav_AddAndRemove() {
        // Given
        let movie = Movie(id: 1, title: "Test", posterPath: nil, releaseDate: nil, voteAverage: nil, overview: nil)
        
        // Initially not favorite
        XCTAssertFalse(viewModel.isFavMovie(movieId: movie.id))
        
        // When add to favorites
        viewModel.toggleFav(for: movie)
        XCTAssertTrue(viewModel.isFavMovie(movieId: movie.id))
        
        // When remove from favorites
        viewModel.toggleFav(for: movie)
        XCTAssertFalse(viewModel.isFavMovie(movieId: movie.id))
    }
    
    // MARK: - Test getting movies from DB (offline)
    
    func testGetFromDB_FillsMoviesList() {
        // Given
        let movieObj = MovieObject()
        movieObj.id = 1
        movieObj.title = "DB Movie"
        movieObj.posterURL = "poster.png"
        movieObj.releaseYear = "2025"
        movieObj.rating = "\(8)"
        movieObj.overview = "overview"
        
        repository.moviesDB = [movieObj]
        
        let expectation = XCTestExpectation(description: "Load movies from DB")
        viewModel.getMoviesList(reset: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.moviesList.count, 1)
            XCTAssertEqual(self.viewModel.moviesList.first?.title, "DB Movie")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Additional tests could include:
    // - Testing error handling
    // - Testing API fetch using a mock network manager
}
