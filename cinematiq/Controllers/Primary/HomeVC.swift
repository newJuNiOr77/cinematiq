//
//  HomeVCViewController.swift
//  cinematiq
//
//  Created by Юрий on 28.07.2023.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case PopularTvs = 1
    case Upcoming = 2
    case TopRated = 3
}


class HomeVC: UIViewController {
    
    // случайный фильм для главного постера
    private var randomTrendingMovie: Title?
    
    private var headerView: HeroHeaderView?
    
    let sectionTitles  = ["В тренде", "Популярные сериалы", "Скоро на экранах", "Самые популярные"]
    
    
    // initialize the main table
    private let homeFeedTable:  UITableView = {
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        configureNavBar()
        
        // main poster от верхнего левого угла на всю ширину вью
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 420))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self]  result in
            switch result  {
            case .success(let titles):
                
                let selectedTitle = titles.randomElement()
                
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            
            case  .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func configureNavBar() {
        var image = UIImage(named: "cinematiq_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
    }
    
    // уведомляем контроллер, что его вью только что разместила свои сабвью  на весь экран
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

// ---------------------------------------

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier ,
                                                       for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
                cell.delegate = self
        
        switch indexPath.section  {
            
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case  .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.PopularTvs.rawValue:
            APICaller.shared.getTopRatedTvs { result in
                switch result {
                case  .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case  .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case  .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:   return UITableViewCell()
        }
        return cell
    }
    
    
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    // Высота хэдера в секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
       
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    // При скроллинге вверх NavBar выталкивается главным постером за экран
    // При скроллинге вниз NavBar остается на месте
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


// запустить трейлер выбранного из коллекции фильма

extension HomeVC: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
