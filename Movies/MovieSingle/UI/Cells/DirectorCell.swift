//
//  DirectorCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class DirectorCell: UITableViewCell {
    
    let movieDirectorLabel: UILabel = {
        let movieDirector = UILabel()
        movieDirector.translatesAutoresizingMaskIntoConstraints = false
        movieDirector.numberOfLines = 0
        movieDirector.adjustsFontSizeToFitWidth = true
        movieDirector.font = UIFont.init(name: "Quicksand-Regular", size: 21)
        movieDirector.textColor = .white
        return movieDirector
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(movieDirectorLabel)
        contentView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        setupConstraints()
    }
    
    func configureCell(director: String){
        selectionStyle = .none
        movieDirectorLabel.text = "Director:  \(director)"
    }
    
    func setupConstraints() {
        
        movieDirectorLabel.snp.makeConstraints{(maker) in
            maker.top.equalToSuperview().inset(5)
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().inset(25)
            maker.trailing.equalToSuperview().inset(25)
        }
    }
}
