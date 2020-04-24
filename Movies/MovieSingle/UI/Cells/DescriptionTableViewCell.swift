//
//  DescriptionTableViewCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    let movieDescriptionLabel: UILabel = {
        let movieDescription = UILabel()
        movieDescription.translatesAutoresizingMaskIntoConstraints = false
        movieDescription.numberOfLines = 0
        movieDescription.adjustsFontSizeToFitWidth = true
        movieDescription.font = UIFont.init(name: "Quicksand-Regular", size: 21)
        movieDescription.textColor = .white
        return movieDescription
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(movieDescriptionLabel)
        contentView.backgroundColor = .init(red: 0.221, green: 0.221, blue: 0.221, alpha: 1)
        setupConstraints()
    }
    
    func configureCell(description: String){
        selectionStyle = .none
        movieDescriptionLabel.text = description
    }
    
    func setupConstraints() {
        
        movieDescriptionLabel.snp.makeConstraints{(maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 25, bottom: 0, right: 25))
        }
    }
}
