//
//  CollectionViewTableViewCell.swift
//  cinematiq
//
//  Created by Юрий on 29.07.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    
    func collectionViewTableViewCellDidTapCell( _ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel   )
}


class CollectionViewTableViewCell:  UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = [ ]
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray4
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    // MARK: - Public
    // fill the array of titles
    
    public func configure(with titles: [ Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath)   as? TitleCollectionViewCell
        else { return UICollectionViewCell() }
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
    
        APICaller.shared.getMovie(with: titleName + "trailer") {  [weak self]  result in
            switch result {
                    case  .success(let videoElement):

                        let title =  self?.titles[indexPath.row]
                        guard let titleOverview = title?.overview  else {
                            return
                        }

                        guard let strongSelf =  self else {
                            return
                        }
                
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                        self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
        }
    }
}

