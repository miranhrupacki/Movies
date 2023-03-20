//
//  TabBarViewController.swift
//  Movies
//
//  Created by Miran Hrupački on 16.03.2023..
//  Copyright © 2023 Miran Hrupački. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    func addChildVCs() {
        let moviesVC = MovieListViewController(networkManager: NetworkManager())
        let searchVC = SearchViewController()
        let favouriteVC = FavouriteViewController()
        
        moviesVC.title = "Movies"
        searchVC.title = "Search"
        favouriteVC.title = "Favourites"
        
        moviesVC.navigationItem.largeTitleDisplayMode = .automatic
        searchVC.navigationItem.largeTitleDisplayMode = .automatic
        favouriteVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: moviesVC)
        let nav2 = UINavigationController(rootViewController: searchVC)
        let nav3 = UINavigationController(rootViewController: favouriteVC)
        nav1.navigationBar.tintColor = .white
        
        nav1.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "house"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star.fill"), tag: 2)
        
        for nav in [nav1, nav2, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class FavouriteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
