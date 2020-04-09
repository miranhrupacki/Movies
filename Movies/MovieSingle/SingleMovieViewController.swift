//
//  SingleMovieViewController.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit

class SingleMovieViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        return tableView
    }()
    
    var backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        return backButton
    }()
    
    init(movie: MovieAPIListView, networkManager: NetworkManager){
        self.movie = movie
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    let movie: MovieAPIListView
    
    var screenData = [MovieCellItem]()
    
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    private var dataSource = [MovieAPIListView]()
    
    private let networkManager: NetworkManager
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        backButton.addTarget(self, action: #selector(toPreviousView(sender:)), for: .touchUpInside)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        configureTableView()
        setupConstraints()
        insertDirector(movieId: movie.id)
    }
    
    @objc func toPreviousView(sender: UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        view.addSubview(backButton)
        
        setTableViewDelegates()
        tableView.estimatedRowHeight = 255
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(GenreCell.self, forCellReuseIdentifier: "GenreCell")
        tableView.register(DirectorCell.self, forCellReuseIdentifier: "DirectorCell")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "DescriptionCell")
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func insertDirector(movieId: Int){
        networkManager.getMovieDirector(from: "https://api.themoviedb.org/3/movie/\(movieId)/credits", movieId: movieId){ (director) in
            if let safeDirector = director{
                self.screenData = self.createScreenData(movie: self.movie, director: safeDirector)
                self.tableView.reloadData()
            }else {
                
            }
        }
    }
    
    func createScreenData(movie: MovieAPIListView, director: Director)  -> [MovieCellItem] {
        var screenData: [MovieCellItem] = []
        screenData.append(MovieCellItem(type: .image, data: movie.imageURL))
        screenData.append(MovieCellItem(type: .title, data: movie.title))
//        screenData.append(MovieCellItem(type: .genre, data: movie.genre))
        screenData.append(MovieCellItem(type: .director, data: director.name))
        screenData.append(MovieCellItem(type: .description, data: movie.description))
        return screenData
    }
    
    func setupConstraints(){
        
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(35)
            maker.leading.equalTo(view.safeAreaLayoutGuide).inset(21)
            maker.trailing.equalTo(view.safeAreaLayoutGuide).inset(330)
        }
    }
}

extension SingleMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = screenData[indexPath.row]
        
        switch item.type {
            
        case .image:
            //guard item.data is UIImage else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as?
                ImageCell else {
                    fatalError("The dequeued cell is not an instance of ImageCell.")}
            cell.configureCell(image: movie.imageURL, movie: movie)
            cell.delegate = self

            return cell
            
        case .title:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as?
                TitleCell else {
                    fatalError("The dequeued cell is not an instance of TitleCell.")}
            cell.configureCell(title: safeData)
            
            return cell
            
//        case .genre:
//            guard let safeData = item.data as? String else {return UITableViewCell()}
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as?
//                GenreCell else {
//                    fatalError("The dequeued cell is not an instance of GenreCell.")}
//
//            cell.configureCell(genre: safeData)
//
//            return cell
//
        case .director:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DirectorCell", for: indexPath) as?
                DirectorCell else {
                    fatalError("The dequeued cell is not an instance of DirectorCell.")}
            cell.configureCell(director: safeData)

            return cell
            
        case .description:
            guard let safeData = item.data as? String else{return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as?
                DescriptionCell else {
                    fatalError("The dequeued cell is not an instance of DescriptionCell.")}
            cell.configureCell(description: safeData)
            
            return cell
            
        }
    }
}

extension SingleMovieViewController: UserInteraction{
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
