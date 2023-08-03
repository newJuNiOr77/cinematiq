//
//  SearchResultsVC.swift
//  cinematiq
//
//  Created by Юрий on 01.08.2023.
//

import UIKit

// New
protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsVCDidTapItem ( _  viewModel: TitlePreviewViewModel)
}

class SearchResultsVC: UIViewController {
    
    // MARK: - Public: should be seen from SearchVC.
    
    public var titles: [Title] = [ ]
    
    public weak var delegate: SearchResultsVCDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3  - 10, height: 180)
        layout.minimumInteritemSpacing  = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell  else  {
            return  UICollectionViewCell()
        }
        //        cell.backgroundColor = .systemMint
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ??  ""
        APICaller.shared.getMovie(with: titleName)  {  [weak self]  result in
            
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultsVCDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView:  videoElement, titleOverview: title.overview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}
