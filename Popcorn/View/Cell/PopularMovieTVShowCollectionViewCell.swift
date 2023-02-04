//
//  PopularMovieTVShowCollectionViewCell.swift
//  Popcorn
//
//  Created by Admin on 03.02.2023.
//

import UIKit
import SDWebImage

class PopularMovieTVShowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
  
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 5
    }
    
    func configureCollectionViewForMovies(with media: Result?){
        movieNameLabel.text = media?.title ?? "No title"
        
        guard let posterPath = media?.posterPath else {return}
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
        posterImageView.sd_setImage(with: posterURL)
    }
    func configureCollectionViewForSerial(with media: Results?){
        movieNameLabel.text = media?.name ?? "No title"
        
        guard let posterPath = media?.posterPath else {return}
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
        posterImageView.sd_setImage(with: posterURL)
    }
}

