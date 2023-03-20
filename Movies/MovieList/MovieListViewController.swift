//
//  MovieListViewController.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var dataSource = [MovieAPIListView]()
    private let networkManager: NetworkManager
    let movieReplaySubject = ReplaySubject<()>.create(bufferSize: 1)
    let watchedButtonSubject = PublishSubject<Int>()
    let favouriteButtonSubject = PublishSubject<Int>()
    
    struct Cells{
        static let movieCell = "MovieTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubscriptions()
        movieReplaySubject.onNext(())

        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = appearance
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
    }
    
    func setupSubscriptions() {
        getData(for: movieReplaySubject).disposed(by: disposeBag)
        initializeWatchedSubject(for: watchedButtonSubject).disposed(by: disposeBag)
        initializeFavouriteSubject(for: favouriteButtonSubject).disposed(by: disposeBag)
    }
    
    private func getData(for subject: ReplaySubject<()>) -> Disposable{
        return subject
            .flatMap { (_) -> Observable<([MovieAPIList], [Genres])> in
                DispatchQueue.main.async {
                    self.indicator.startAnimating()
                }
                return Observable.zip(self.networkManager.getData(url: "https://api.themoviedb.org/3/movie/now_playing") as Observable<[MovieAPIList]>, self.networkManager.getData(url: "https://api.themoviedb.org/3/genre/movie/list") as Observable<[Genres]>)
        }
        .map({ (data) -> [MovieAPIListView] in
            return self.createScreenData(data: data)
        })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self](data) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                self.dataSource = data
                self.tableView.reloadData()
            }, onError: {[unowned self] error in
                self.showAlertWith(title: "Network error", message: error.localizedDescription)
            })
    }
    
    private func createScreenData(data: (list: [MovieAPIList], genres: [Genres])) -> ([MovieAPIListView]){
        
        for movie in data.list{
            var genreList: [String] = []
            for genre in data.genres{
                if movie.genreIds.contains(genre.id){
                    genreList.append(genre.name)
                }
            }
            return data.list.map { (data) -> MovieAPIListView in
                let year = DateUtils.getYearFromDate(stringDate: data.releaseDate)
                let watched = DatabaseManager.isMovieWatched(with: data.id)
                let favourite = DatabaseManager.isMovieFovurited(with: data.id)
                return MovieAPIListView(id: data.id,
                                        title: data.originalTitle,
                                        imageURL: data.posterPath ?? "",
                                        description: data.overview,
                                        year: year,
                                        watched: watched,
                                        favourite: favourite,
                                        genres: genreList)
            }
        }
        return dataSource
    }
    
    func initializeWatchedSubject(for subject: PublishSubject<Int>) -> Disposable{
        return subject
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieId in
                self.watchedMoviePressed(with: movieId)
            })
    }
    
    func initializeFavouriteSubject(for subject: PublishSubject<Int>) -> Disposable{
        return subject
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] movieId in
            self.favouriteMoviePressed(with: movieId)
        })
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
        cell.favouritePressed = { [unowned self] (id) in
            self.favouriteButtonSubject.onNext(id)
        }
        cell.watchedPressed = { [unowned self] (id) in
            self.watchedButtonSubject.onNext(id)
        }
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


