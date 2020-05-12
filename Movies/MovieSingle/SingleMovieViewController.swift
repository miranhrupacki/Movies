//
//  SingleMovieViewController.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

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
    
    let disposeBag = DisposeBag()
    var movie: MovieAPIListView
    var screenData = [MovieCellItem]()
    weak var updateDelegate: UserInteraction?
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private let networkManager: NetworkManager
    let watchedButtonSubject = PublishSubject<Int>()
    let favouriteButtonSubject = PublishSubject<Int>()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubscriptions()
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
        
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(GenreTableViewCell.self, forCellReuseIdentifier: "GenreCell")
        tableView.register(DirectorTableViewCell.self, forCellReuseIdentifier: "DirectorCell")
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionCell")
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func insertDirector(movieId: Int){
        indicator.startAnimating()
        networkManager.getMovieDirector(url: "https://api.themoviedb.org/3/movie/\(movieId)/credits", movieId: movieId)
            .subscribe(
                onNext: {[unowned self](directorList) in
                    self.screenData = self.createScreenData(movie: self.movie, director: directorList)
                    self.tableView.reloadData()
                }, onError: {[unowned self] error in
                    self.showAlertWith(title: "Network error", message: "Something went wrong, directors couldn't load")
            }).disposed(by: disposeBag)
    }
    
    func createScreenData(movie: MovieAPIListView, director: Director)  -> [MovieCellItem] {
        var screenData: [MovieCellItem] = []
        screenData.append(MovieCellItem(type: .image, data: movie.imageURL))
        screenData.append(MovieCellItem(type: .title, data: movie.title))
        screenData.append(MovieCellItem(type: .genre, data: movie.genres))
        screenData.append(MovieCellItem(type: .director, data: director.name))
        screenData.append(MovieCellItem(type: .description, data: movie.description))
        return screenData
    }
    
    func setupSubscriptions() {
        initializeWatchedSubject(for: watchedButtonSubject).disposed(by: disposeBag)
        initializeFavouriteSubject(for: favouriteButtonSubject).disposed(by: disposeBag)
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
                ImageTableViewCell else {
                    fatalError("The dequeued cell is not an instance of ImageCell.")}
            cell.configureCell(image: movie.imageURL, movie: movie)
            
            cell.favouritePressed = { [unowned self] (id) in
                self.favouriteButtonSubject.onNext(id)
            }
            cell.watchedPressed = { [unowned self] (id) in
                self.watchedButtonSubject.onNext(id)
            }
            
            return cell
            
        case .title:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as?
                TitleTableViewCell else {
                    fatalError("The dequeued cell is not an instance of TitleCell.")}
            cell.configureCell(title: safeData)
            
            return cell
            
        case .genre:
            guard let safeData = item.data as? [String] else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as?
                GenreTableViewCell else {
                    fatalError("The dequeued cell is not an instance of GenreCell.")}
            cell.configureCell(text: safeData)
            
            return cell
            
        case .director:
            guard let safeData = item.data as? String else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DirectorCell", for: indexPath) as?
                DirectorTableViewCell else {
                    fatalError("The dequeued cell is not an instance of DirectorCell.")}
            cell.configureCell(director: safeData)
            
            return cell
            
        case .description:
            guard let safeData = item.data as? String else{return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as?
                DescriptionTableViewCell else {
                    fatalError("The dequeued cell is not an instance of DescriptionCell.")}
            cell.configureCell(description: safeData)
            
            return cell
            
        }
    }
}

extension SingleMovieViewController: UserInteraction{
    func watchedMoviePressed(with id: Int) {
        
        movie.watched = !movie.watched
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        updateDelegate?.watchedMoviePressed(with: id)
    }
    
    func favouriteMoviePressed(with id: Int) {
        
        movie.favourite = !movie.favourite
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        updateDelegate?.favouriteMoviePressed(with: id)
    }
}
