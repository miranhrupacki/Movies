//
//  GenreTableViewCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    
    let movieGenreLabel: UILabel = {
        let movieGenre = UILabel()
        movieGenre.translatesAutoresizingMaskIntoConstraints = false
        movieGenre.numberOfLines = 0
        movieGenre.adjustsFontSizeToFitWidth = true
        movieGenre.font = UIFont.init(name: "Quicksand-Regular", size: 21)
        movieGenre.textColor = .white
        return movieGenre
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(movieGenreLabel)
        contentView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        setupConstraints()
    }
    
    func configureCell(genre: String){
        selectionStyle = .none
        movieGenreLabel.text = genre
    }
    
    func setupConstraints() {
        
        movieGenreLabel.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(5)
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().inset(25)
            maker.trailing.equalToSuperview().inset(25)
        }
    }
}
