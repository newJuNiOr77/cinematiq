//
//  SearchVC.swift
//  cinematiq
//
//  Created by Юрий on 28.07.2023.
//

import UIKit

class SearchVС: UIViewController {
    
    private var titles: [Title] = [ ]
    
    private let discoverTable: UITableView = {
        let table  = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        
        let controller = UISearchController.init(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Найти фильм или сериал"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Поиск"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        
        fetchDiscover()
        searchController.searchResultsUpdater = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscover() {
        APICaller.shared.getDiscoveredMovies() { [weak self] result in
            switch result {
            case .success( let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure (let error):
                print(error.localizedDescription)
            }
        }
    }
}



extension  SearchVС: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell  else {
            return UITableViewCell()
        }
        
        let  title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_name  ??  title.original_title ) ??  "Unknown title name",
                                            posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
//------------------------------------

extension  SearchVС: UISearchResultsUpdating , SearchResultsVCDelegate {
    
    func updateSearchResults(for searchController: UISearchController)  {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in:  .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let  resultsController = searchController.searchResultsController as? SearchResultsVC  else {
            return
        }
        
        resultsController.delegate =  self
        
        
        APICaller.shared.search(with: query)  { result in
            DispatchQueue.main.sync {
                switch result {
                        case .success(let titles):
                            resultsController.titles = titles
                            resultsController.searchResultCollectionView.reloadData()
                        case .failure(let error):
                            print(error.localizedDescription)
                }
            }
        }
    }

    func searchResultsVCDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    // Запуск трейлера при нажатии на постер
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        APICaller.shared.getMovie(with: titleName) { [weak self]  result  in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async  {
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
