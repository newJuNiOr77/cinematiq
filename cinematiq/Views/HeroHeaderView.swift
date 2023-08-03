//
//  HeroHeader.swift
//  cinematiq
//
//  Created by Юрий on 30.07.2023.
//

import UIKit
import Kingfisher

class HeroHeaderView: UIView {

    // no need to constraint
    private let heroImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds =  true
        image.image = UIImage(named: "arni")
        return image
    }()
    
    // Градиент для главного постера
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        // for Dark theme:
//        gradientLayer.colors = [
//            UIColor.systemBackground.cgColor,
//            UIColor.clear.cgColor
//        ]
        
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)")   else {
            return
        }
        heroImageView.kf.setImage(with: url, options: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = self.bounds
    }
}
