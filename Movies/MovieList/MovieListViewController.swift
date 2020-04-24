//
//  MovieListViewController.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        return tableView
    }()
    
    let alert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }()
    
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var dataSource = [MovieAPIListView]()
        
    private let networkManager: NetworkManager
    
    struct Cells{
        static let movieCell = "MovieTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(networkManager: NetworkManager){
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        configureTableView()
        
        setupConstraints()
        getData()
    }
    
    func getData(){
        networkManager.getData(url: "https://api.themoviedb.org/3/movie/now_playing") {
            [unowned self](movieList) in
            if let safeMovieList = movieList{
                self.dataSource = self.createScreenData(from: safeMovieList)
                self.tableView.reloadData()
            } else {
                self.alert.title = "Movies error"
                self.alert.message = "Something went wrong, movies couldn't load"
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
//    func getGenres(){
//        indicator.startAnimating()
//        networkManager.getData(from: "https://api.themoviedb.org/3/genre/movie/list") { [unowned self](genres) in
//            self.indicator.stopAnimating()
//            if let safeGenreList = genres{
//                self.dataSource = self.createScreenData(from: safeGenreList)
//                self.tableView.reloadData()
//            }else{
//                
//            }
//        }
//    }
    
    private func createScreenData(from data: [MovieAPIList]) -> [MovieAPIListView]{
        return data.map { (data) -> MovieAPIListView in
            let year = DateUtils.getYearFromDate(stringDate: data.releaseDate)
            let watched = DatabaseManager.isMovieWatched(with: data.id)
            let favourite = DatabaseManager.isMovieFovurited(with: data.id)
            return MovieAPIListView(id: data.id,
                                    title: data.originalTitle,
                                    imageURL: data.posterPath,
                                    description: data.overview,
                                    year: year,
                                    watched: watched,
                                    favourite: favourite)
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        setTableViewDelegates()
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Cells.movieCell)
    }
    
    func setupConstraints(){
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieCell) as! MovieTableViewCell
        
        let movie = dataSource[indexPath.row]
        cell.configure(movie: movie)
        cell.updateDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        let vc = SingleMovieViewController(movie: item, networkManager: networkManager)
        vc.updateDelegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieListViewController: UserInteraction{
    func watchedMoviePressed(with id: Int) {
        guard let movie = dataSource.enumerated().first(where: { (movie) -> Bool in
            return movie.element.id == id
        }) else {return}
        !movie.element.watched ? DatabaseManager.watchedMovie(with: movie.element.id) : DatabaseManager.removeMovieFromWatched(with: movie.element.id)
        dataSource[movie.offset].watched = !movie.element.watched
        tableView.reloadRows(at: [IndexPath(row: movie.offset, section: 0)], with: .none)
    }
    
    func favouriteMoviePressed(with id: Int) {
        guard let movie = dataSource.enumerated().first(where: { (movie) -> Bool in
            return movie.element.id == id
        }) else {return}
        !movie.element.favourite ? DatabaseManager.favouritedMovie(with: movie.element.id) : DatabaseManager.removeMovieFromFavourite(with: movie.element.id)
        dataSource[movie.offset].favourite = !movie.element.favourite
        tableView.reloadRows(at: [IndexPath(row: movie.offset, section: 0)], with: .none)
    }
}


