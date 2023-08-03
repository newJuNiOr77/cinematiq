//
//  TitlePreviewVC.swift
//  cinematiq
//
//  Created by Юрий on 01.08.2023.
//

import UIKit
import WebKit
import SnapKit

class TitlePreviewVC:  UIViewController {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.spacing = 15
        stackView.backgroundColor = .systemBackground
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
        
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Terminator"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Возможно, лучший фильм для всех, кому 5+"
        label.numberOfLines = 0
        return label
    }()
    
    let downloadButton: UIButton  = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setTitle("Загрузить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(webView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(overviewLabel)
        stackView.addArrangedSubview(downloadButton)
    }
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(700)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(50)
            make.leading.equalTo(stackView.snp.leading).offset(10)
            make.trailing.equalTo(stackView.snp.trailing).inset(10)
            make.height.equalTo(300)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(10)
            make.leading.equalTo(stackView.snp.leading).offset(10)
            make.trailing.equalTo(stackView.snp.trailing).inset(10)
            make.centerX.equalTo(stackView.snp.centerX)
        }
        overviewLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading).offset(10)
            make.trailing.equalTo(stackView.snp.trailing).inset(10)
            make.centerX.equalTo(stackView.snp.centerX)
        }
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(10)
            make.width.equalTo(130)
            make.height.equalTo(40)
            make.centerX.equalTo(stackView.snp.centerX)
        }
    }
    
    
    
    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text  = model.title
        overviewLabel.text =  model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)")    else{
            return
        }
        webView.load(URLRequest(url: url))
    }
    
}

