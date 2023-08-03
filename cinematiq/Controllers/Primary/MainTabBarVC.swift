//
//  ViewController.swift
//  cinematiq
//
//  Created by Юрий on 28.07.2023.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: UpcomingVC())
        let vc3 = UINavigationController(rootViewController: SearchVС())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        vc1.title = "Начало"
        vc2.title = "Скоро на экранах"
        vc3.title = "Поиск"
        
        tabBar.tintColor = .label   // dark and light mode available
        setViewControllers([vc1, vc2, vc3], animated: true)
        
    }
}

