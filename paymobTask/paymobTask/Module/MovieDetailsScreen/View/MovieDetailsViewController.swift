//
//  MovieDetailsViewController.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 26/08/2025.
//

import UIKit
import Combine
class MovieDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var movieVoting: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var addToFavButtonOutlet: UIButton!
    var movieDetailsVM : MovieDetailsViewModel!
    @IBAction func addToFavButton(_ sender: Any) {
        if movieDetailsVM.isFav {
            movieDetailsVM.removeMovieFromDB()
            addToFavButtonOutlet.setImage(UIImage(systemName: "star") , for: .normal)
        }else {
            movieDetailsVM.saveToFavorites()
            addToFavButtonOutlet.setImage(UIImage(systemName: "star.fill") , for: .normal)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        movieTitleLabel.text = "Title: " + "\(movieDetailsVM.title)"
        overviewTextView.text = "Overview: " + "\(movieDetailsVM.description)"
        movieVoting.text = "Vote average: " + "\(movieDetailsVM.rating)"
        languageLabel.text = "Original language: " + "\(movieDetailsVM.movieLang)"
        if let url = movieDetailsVM.posterURL {
            posterImage.setCachedImage(
                urlString: "\(url)",
                placeholder: UIImage(named: "movie-placeholder")
            )
        }
       
        
        addToFavButtonOutlet.setImage( movieDetailsVM.isFav ?
                                       UIImage(systemName: "star.fill") : UIImage(systemName: "star")  , for: .normal)
        
    }
}
