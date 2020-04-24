//
//  TitleTableViewCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    let movieTitleLabel: UILabel = {
        let movieTitle = UILabel()
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.numberOfLines = 0
        movieTitle.adjustsFontSizeToFitWidth = true
        movieTitle.font = UIFont.init(name: "Quicksand-Medium", size: 29)
        movieTitle.textColor = .white
        return movieTitle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI(){
        contentView.addSubview(movieTitleLabel)
        contentView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        setupConstraints()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String){
        selectionStyle = .none
        movieTitleLabel.text = title
    }
    
    func setupConstraints() {
        
        movieTitleLabel.snp.makeConstraints{(maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 25, bottom: 0, right: 25))
        }
    }
}
