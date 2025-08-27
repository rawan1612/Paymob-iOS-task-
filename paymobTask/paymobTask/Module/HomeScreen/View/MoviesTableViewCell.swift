//
//  MoviesTableViewCell.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import UIKit
import SkeletonView

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieFavButton: UIButton!
    @IBOutlet weak var movieRankLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    var favButtonAction: (() -> Void)?   // closure

    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true

    }
    func configure(isFav: Bool) {
          let imageName = isFav ? "star.fill" : "star"
          movieFavButton.setImage(UIImage(systemName: imageName), for: .normal)
      }
    @IBAction func favButtonTapped(_ sender: UIButton) {
        favButtonAction?()   // call back to VC
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
