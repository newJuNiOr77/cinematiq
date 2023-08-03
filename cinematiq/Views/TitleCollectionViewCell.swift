//
//  TitleCollectionViewCell.swift
//  cinematiq
//
//  Created by Юрий on 31.07.2023.
//

import UIKit
import Kingfisher

// the custom cell for Collection

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    //MARK: -  Public
    //Kingfisher: Fetch the poster image by its url, round the corners
    
    public func configure(with model:  String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)")    else {
            return
        }
        
      let processor = RoundCornerImageProcessor(cornerRadius: 40)
        posterImageView.kf.setImage(with: url, options: [ .processor(processor)])
    }
}
