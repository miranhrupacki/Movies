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
    
    func configureCell(text: [String]){
        var genreText = ""
        for (index, genre) in text.enumerated(){
            if index == 0{
                genreText = genreText + genre
            }else{
                genreText = genreText + ", \(genre)"
            }
        }
        selectionStyle = .none
        movieGenreLabel.text = genreText
    }
    
    func setupConstraints() {
        
        movieGenreLabel.snp.makeConstraints{(maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 25, bottom: 0, right: 25))
        }
    }
}
