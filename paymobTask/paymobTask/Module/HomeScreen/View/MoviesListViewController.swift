//
//  MoviesListViewController.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import UIKit
import Combine
import Kingfisher
import SkeletonView
import RealmSwift
class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    let moviesListViewModel = MoviesListViewModel()
    private var cancellables = Set<AnyCancellable>()
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        moviesListViewModel.getMoviesList(reset: true)
        bindToViewModel()
        setFavObserver()
    }
    
    
    func setupUI(){
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        moviesTableView.isSkeletonable = true
        moviesTableView.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: .lightGray),
            animation: nil,
            transition: .crossDissolve(0.25))
        
    }
    
    func bindToViewModel(){
        moviesListViewModel.$moviesList.receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                if !(response.isEmpty) {
                    if self.view.sk.isSkeletonActive {
                        self.moviesTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    } else {
                        self.moviesTableView.reloadData()
                    }
                    
                } else {
                    print("No data or error occurred")
                    
                }
            }.store(in: &cancellables)
        
        moviesListViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    self.moviesTableView.reloadSections(IndexSet(integer: 0), with: .none)
                }
            }
            .store(in: &cancellables)
        
        moviesListViewModel.$alertItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alertItem in
                guard let self = self, let alertItem = alertItem else { return }
                self.presentAlert(alertItem)
            }
            .store(in: &cancellables)
    }
    
    
    func setFavObserver(){
        let favorites = RealmManager.shared.getRealm().objects(MovieObject.self)
        
        notificationToken = favorites.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.moviesTableView.reloadData()
            case .update(_, _, _, _):
                self?.moviesTableView.reloadData() // or update specific rows if needed
            case .error(let error):
                print("Realm error: \(error)")
            }
        }
    }
    deinit {
          notificationToken?.invalidate()
      }
    
}

extension MoviesListViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesListViewModel.moviesList.count + (moviesListViewModel.isLoading ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < moviesListViewModel.moviesList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
            
            
            let movie = moviesListViewModel.moviesList[indexPath.row]
            cell.movieNameLabel.text = movie.title
             if let posterPath = movie.posterPath,
                let url = URL(string: "\(Constants.BASE_IMAGE_URL)\(posterPath)") {
                 cell.moviePosterImage.setCachedImage(
                     urlString: "\(url)",
                     placeholder: UIImage(named: "placeholder")
                 )
             }
             
            cell.movieRankLabel.text = "\(movie.voteAverage)"
            cell.movieYearLabel.text = movie.releaseDate
            let isFav = moviesListViewModel.isFavMovie(movieId: movie.id)
            cell.configure(isFav: isFav)
            cell.favButtonAction = { [weak self] in
                self?.moviesListViewModel.toggleFav(for: movie)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
            
        }else {
            // adding loading cell after request pagination
            let loadingCell = UITableViewCell(style: .default, reuseIdentifier: "LoadingCell")
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.center = loadingCell.contentView.center
            spinner.startAnimating()
            loadingCell.contentView.addSubview(spinner)
            return loadingCell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    // pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = moviesListViewModel.moviesList.count - 5
        if indexPath.row == threshold && !moviesListViewModel.isLoading {
            self.moviesListViewModel.getMoviesList()
            
        }
    }
    
}


extension MoviesListViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MoviesTableViewCell"
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
extension MoviesListViewController {
    func presentAlert(_ alertItem: AlertItem) {
        let alert = UIAlertController(
            title: alertItem.title,
            message: alertItem.message,
            preferredStyle: .alert
        )

         let button = alertItem.dismissButton
            alert.addAction(button)

        present(alert, animated: true)
    }
}

