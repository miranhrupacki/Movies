//
//  ImageTableViewCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let movieImageView: UIImageView = {
        let movieImage = UIImageView()
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        movieImage.clipsToBounds = true
        movieImage.layer.cornerRadius = 20
        movieImage.layer.maskedCorners = [.layerMaxXMaxYCorner, . layerMinXMaxYCorner]
        return movieImage
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
    
    weak var delegate: UserInteraction?
    
    internal var id: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI(){
        watchedButton.addTarget(self, action: #selector(watchedButtonPressed), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(favouriteMoviePressed), for: .touchUpInside)
        contentView.addSubview(movieImageView)
        contentView.addSubview(watchedButton)
        contentView.addSubview(favouriteButton)
        movieImageView.layer.addSublayer(gradientLayer)
        contentView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        setupConstraints()
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: String, movie: MovieAPIListView){
        id = movie.id
        movieImageView.loadImage(with: image)
        watchedButton.isSelected = movie.watched
        favouriteButton.isSelected = movie.favourite
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = movieImageView.bounds
    }
    
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.init(red: 0.106, green: 0.106, blue: 0.118, alpha: 0).cgColor, UIColor.init(red: 0.106, green: 0.106, blue: 0.118, alpha: 0.9).cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    //MARK: CONSTRAINTS
    
    func setupConstraints(){
        movieImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.height.equalTo(255)
        }
        
        favouriteButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().inset(35)
            maker.leading.equalToSuperview().inset(325)
            maker.trailing.equalToSuperview().inset(15)
        }
        
        watchedButton.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(35)
            maker.leading.equalToSuperview().inset(275)
            maker.trailing.equalToSuperview().inset(65)
        }
    }
    
}

extension ImageTableViewCell {
    @objc func watchedButtonPressed(){
        delegate?.watchedMoviePressed(with: id)
    }
    
    @objc func favouriteMoviePressed(){
        delegate?.favouriteMoviePressed(with: id)
    }
}
