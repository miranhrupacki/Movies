//
//  ImageCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI(){
        favouriteButton.addTarget(self, action: #selector(buttonToggle(sender:)), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(buttonToggle(sender:)), for: .touchUpInside)
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
    
    func configureCell(image: String){
           movieImageView.loadImage(with: image)
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = movieImageView.bounds
    }
    
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.init(red: 0.106, green: 0.106, blue: 0.118, alpha: 0).cgColor, UIColor.init(red: 0.106, green: 0.106, blue: 0.118, alpha: 0.9).cgColor]
        gradientLayer.locations = [0, 1]
    }
    
    @objc func buttonToggle(sender: UIButton) {
        if favouriteButton.isTouchInside == true {
            favouriteButton.isSelected.toggle()
        }
        if watchedButton.isTouchInside == true {
            watchedButton.isSelected.toggle()
        }
    }
    
    //MARK: CONSTRAINTS
    
    func setupConstraints(){
        movieImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        favouriteButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().inset(35)
            maker.leading.equalToSuperview().offset(325)
            maker.trailing.equalToSuperview().inset(15)
        }
        
        watchedButton.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(35)
            maker.leading.equalToSuperview().offset(275)
            maker.trailing.equalToSuperview().inset(65)
        }
    }
    
}
