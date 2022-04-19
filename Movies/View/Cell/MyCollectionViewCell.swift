//
//  MyCollectionViewCell.swift
//  Movies
//
//  Created by W.D. on 9/02/22.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MyCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var movieTitleLabel: UILabel!
    @IBOutlet private var movieYearLabel: UILabel!
    @IBOutlet private var moviePosterImageView: UIImageView!
    
    // MARK: - Internal Methods
    
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.Title
        self.movieYearLabel.text = model.Year
        let url = model.Poster ?? ""
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.moviePosterImageView.image = UIImage(data: data)
        }
        
    }
}
