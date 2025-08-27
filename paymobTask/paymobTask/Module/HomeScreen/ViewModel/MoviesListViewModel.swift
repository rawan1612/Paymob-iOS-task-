//
//  MoviesListViewModel.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import Foundation
import Combine
import UIKit
import RealmSwift

protocol MoviesListViewModelProtocol: ObservableObject {
    func getMoviesList(reset: Bool)
    
}
final class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published var moviesList: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var alertItem: AlertItem?
    @Published var movies: [MovieObject] = []
    private let repository: MoviesRepositoryProtocol
    var cancelables = Set<AnyCancellable>()
    private var currentPage = 1
    private var totalPages = 1
    private var isFetching = false
    
    init(repository: MoviesRepositoryProtocol = MoviesRepository()) {
        self.repository = repository
    }
    func isFavMovie(movieId : Int) -> Bool{
         let result = repository.getMovie(by: movieId)
          
             return (result != nil ? true : false)
    }
    
    func getMoviesList(reset: Bool = false) {
        if isConnectedToInternet() {
            guard !isFetching else { return }
            
            if reset {
                currentPage = 1
                moviesList.removeAll()
            }
            
            // Stop if no more pages
            guard currentPage <= totalPages else { return }
            
            isLoading = true
            errorMessage = nil
            isFetching = true
            
            let url = "\(Constants.BASE_URL)?page=\(currentPage)"
            
            
            
            NetworkManager.shared.getResponse(
                url: url,
                headers: ["Authorization": "Bearer \(Secrets.API_KEY)"],
                responseClass: MovieResponse.self
            )
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                self.isFetching = false
                if case let .failure(error) = completion {
                    self.handleError(error: error)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.isFetching = false
                
                
                moviesList.append(contentsOf: response.results)
                self.totalPages = response.totalPages
                self.currentPage += 1
                
                
            }
            .store(in: &cancelables)
        }
        else {
            getfromDB()
        }
    }
    func getfromDB(){
        let storedMovies = RealmManager.shared.getRealm().objects(MovieObject.self)
        self.moviesList.removeAll()
        self.moviesList.append(contentsOf:  storedMovies.map { Movie(id: $0.id, title: $0.title, posterPath: $0.posterURL, releaseDate: $0.releaseYear, voteAverage: Double($0.rating), overview: $0.overview) })
    }
    func toggleFav(for movie : Movie){
        if isFavMovie(movieId: movie.id){
            removeFromFav(movieID: movie.id)
        }else {
            addToFav(movie: movie)
        }
    }
    func addToFav(movie : Movie){
        let movieDB = MovieObject(from: movie)
        repository.addOrUpdate(movieDB)
    }
    
    func removeFromFav(movieID: Int){
        repository.removeFavorite(movieId: movieID)
    }
    
    private func isConnectedToInternet() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    private func handleError(error: MovieError) {
        switch error {
        case .invalidURL:
            self.alertItem = AlertContext.invalidUrl
        case .invalidResponse:
            self.alertItem = AlertContext.invalidResponse
        case .invalidData:
            self.alertItem = AlertContext.invalidData
        case .unableToComplete:
            self.alertItem = AlertContext.unableToComplete
        case .other(errorMessage: let errorMessage):
            self.alertItem = AlertItem(title: "Problem happened!", message: "\(errorMessage ?? "")", dismissButton: UIAlertAction(title: "OK", style: .default, handler: nil) )
        }
    }
    
}

