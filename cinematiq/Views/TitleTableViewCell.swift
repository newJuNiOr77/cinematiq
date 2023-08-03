//
//  TitleTableViewCell.swift
//  cinematiq
//
//  Created by Юрий on 01.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

// Cell for UpcomingVC

class TitleTableViewCell: UITableViewCell {

   static let identifier = "TitleTableViewCell"
    
    private let titlePosterImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image,  for: .normal)
        button.tintColor = .label
        return button
    }()
     
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
    }
    
    
    private func setupConstraints() {
        
        titlePosterImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView) .offset(25)
            make.top.equalTo(contentView) .offset(5)
            make.bottom.equalTo(contentView) .offset(-5)
            make.width.equalTo(90)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titlePosterImageView).offset(105)
            make.trailing.equalTo(contentView).offset( -60)
            make.centerY.equalTo(contentView)
        }
        playTitleButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset( -20)
            make.centerY.equalTo(contentView)
        }
    }
        
    // MARK: -  Public:  fetch images for posters by url
 
    public func configure(with model: TitleViewModel) {
       
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)")   else {
            return
        }
        titlePosterImageView.kf.setImage(with: url, options: nil)
        titleLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


