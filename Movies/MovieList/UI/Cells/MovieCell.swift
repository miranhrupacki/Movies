//
//  MovieCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .init(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        return container
    }()
    var movieImageView: UIImageView = {
        let movieImageView = UIImageView()
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.layer.cornerRadius = 10
        movieImageView.clipsToBounds = true
        return movieImageView
    }()
    
    let movieTitleLabel: UILabel = {
        let movieTitleLabel = UILabel()
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.adjustsFontSizeToFitWidth = true
        movieTitleLabel.font = UIFont.init(name: "Quicksand-Bold", size: 17)
        movieTitleLabel.textColor = .white
        return movieTitleLabel
    }()
    
    let movieGenreLabel: UILabel = {
        let movieGenreLabel = UILabel()
        movieGenreLabel.translatesAutoresizingMaskIntoConstraints = false
        movieGenreLabel.numberOfLines = 0
        movieGenreLabel.adjustsFontSizeToFitWidth = true
        movieGenreLabel.font = UIFont.init(name: "Quicksand-Regular", size: 15)
        movieGenreLabel.textColor = .white
        return movieGenreLabel
    }()
    
    let movieYearLabel: UILabel = {
        let movieYearLabel = UILabel()
        movieYearLabel.translatesAutoresizingMaskIntoConstraints = false
        movieYearLabel.numberOfLines = 0
        movieYearLabel.adjustsFontSizeToFitWidth = true
        movieYearLabel.font = UIFont.init(name: "Quicksand-Medium", size: 21)
        movieYearLabel.textColor = .white
        return movieYearLabel
    }()
    
    let watchedButton: UIButton = {
        let watchedButton = UIButton()
        watchedButton.translatesAutoresizingMaskIntoConstraints = false
        watchedButton.setImage(UIImage(named: "unselectedWatched"), for: .normal)
        watchedButton.setImage(UIImage(named: "selectedWatched"), for: .selected)
        watchedButton.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 35, height: 35))
        return watchedButton
    }()
    
    let favouriteButton: UIButton = {
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.setImage(UIImage(named: "unselectedStar"), for: .normal)
        favouriteButton.setImage(UIImage(named: "selectedStar"), for: .selected)
        favouriteButton.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 35, height: 35))
        return favouriteButton
    }()
    
    let gradientLayer = CAGradientLayer()
    
    internal var id: Int = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        watchedButton.addTarget(self, action: #selector(buttonToggle(sender:)), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(buttonToggle(sender:)), for: .touchUpInside)
        movieImageView.layer.addSublayer(gradientLayer)
        
        contentView.addSubview(container)
        container.addSubview(movieImageView)
        container.addSubview(movieTitleLabel)
        container.addSubview(movieGenreLabel)
        container.addSubview(movieYearLabel)
        container.addSubview(watchedButton)
        container.addSubview(favouriteButton)
        
        contentView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        
        setupConstraints()
        setupGradientLayer()
    }
    
    func configure(movie: MovieAPIListView){
        id = movie.id
        movieTitleLabel.text = movie.title
        //movieGenreLabel.text = movie.genres
        movieImageView.loadImage(with: movie.imageURL)
        movieYearLabel.text = movie.year
    }

    @objc func buttonToggle(sender: UIButton) {
        if favouriteButton.isTouchInside == true {
            favouriteButton.isSelected.toggle()
        }
        if watchedButton.isTouchInside == true {
            watchedButton.isSelected.toggle()
        }
    }
    
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.init(red: 0.106, green: 0.106, blue: 0.118, alpha: 0).cgColor, UIColor.init(red: 0.106, green: 0.106, blue: 0.118, alpha: 0.9).cgColor]
        gradientLayer.locations = [0, 0.82]
    }
    
    //MARK: CONSTRAINTS
    
    func setupConstraints(){
        
        container.snp.makeConstraints {(maker) in
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.leading.equalToSuperview().inset(15)
            maker.trailing.equalToSuperview().inset(15)
        }
        
        movieImageView.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.width.equalTo(155)
            maker.height.equalTo(155)
        }
        
        movieTitleLabel.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(15)
            maker.leading.equalTo(movieImageView.snp.trailing).inset(-15)
            maker.trailing.equalToSuperview().inset(12)
        }
                
        movieGenreLabel.snp.makeConstraints{(maker) in
            maker.top.equalTo(movieTitleLabel.snp.bottom).inset(-1)
            maker.leading.equalTo(movieImageView.snp.trailing).inset(-20)
            maker.trailing.equalToSuperview().inset(-15)
        }
        
        movieYearLabel.snp.makeConstraints{(maker) in
            maker.top.equalTo(movieImageView.snp.top).inset(125)
            maker.leading.equalTo(movieImageView.snp.leading).inset(55)
        }
        
        favouriteButton.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(111)
            maker.leading.equalTo(movieImageView.snp.trailing).inset(-140)
            maker.trailing.equalToSuperview().inset(15)
        }
        
        watchedButton.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(111)
            maker.leading.equalTo(movieImageView.snp.trailing).inset(-90)
            maker.trailing.equalToSuperview().inset(65)
        }
    }
}

extension UIImageView{
    
     func loadImage(with imageURL: String){
        if let imageURL = URL(string: "https://image.tmdb.org/t/p/w1280"+imageURL) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let safeImage = UIImage(data: data)
                    DispatchQueue.main.async {[weak self] in
                        self?.image = safeImage
                    }
                }
            }
        }
    }
}
