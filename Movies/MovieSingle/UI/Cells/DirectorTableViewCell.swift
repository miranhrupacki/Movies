//
//  DirectorTableViewCell.swift
//  Movies
//
//  Created by Miran Hrupački on 30/03/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import UIKit

class DirectorTableViewCell: UITableViewCell {
    
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
        let message = NSMutableAttributedString(string: "Director: ", attributes: [NSAttributedString.Key.font : UIFont(name: "Quicksand-Bold", size: 21)!, NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)])
        message.append(NSAttributedString(string: director, attributes: [NSAttributedString.Key.font : UIFont(name: "Quicksand-Regular", size: 21)!]))
        movieDirectorLabel.attributedText = message
    }
    
    func setupConstraints() {
        
        movieDirectorLabel.snp.makeConstraints{(maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 25, bottom: 0, right: 25))
        }
    }
}
