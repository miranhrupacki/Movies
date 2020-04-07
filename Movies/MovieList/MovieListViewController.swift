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
    
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    private var dataSource = [MovieAPIListView]()
    
    private let networkManager: NetworkManager
    
    struct Cells{
        static let movieCell = "MovieCell"
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
        indicator.startAnimating()
        networkManager.getData(from: "https://api.themoviedb.org/3/movie/now_playing") { [unowned self](movieList) in
            self.indicator.stopAnimating()
            if let safeMovieList = movieList{
                self.dataSource = self.createScreenData(from: safeMovieList)
                self.tableView.reloadData()
            }else{
                
            }
        }
    }
    

    
    
    
    //    func getGenres(){
    //           indicator.startAnimating()
    //           networkManager.getData(from: "https://api.themoviedb.org/3/genre/movie/list") { [unowned self](genres) in
    //               self.indicator.stopAnimating()
    //               if let safeGenreList = genres{
    //                   self.dataSource = self.createScreenData(from: safeGenreList)
    //                   self.tableView.reloadData()
    //               }else{
    //
    //               }
    //           }
    //       }
    
    private func createScreenData(from data: [MovieAPIList]) -> [MovieAPIListView]{
        return data.map { (data) -> MovieAPIListView in
            //insertDirector(movieId: data.id)
            let year = DateUtils.getYearFromDate(stringDate: data.releaseDate)
            return MovieAPIListView(id: data.id,
                                    title: data.originalTitle,
                                    imageURL: data.posterPath,
                                    description: data.overview,
                                    year: year)
            //                                    genres: data.genreIds)
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        setTableViewDelegates()
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieCell.self, forCellReuseIdentifier: Cells.movieCell)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieCell) as! MovieCell
        
        
        let movie = dataSource[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        let vc = SingleMovieViewController(movie: item, networkManager: networkManager)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

