//
//  MovieAPIListView.swift
//  Movies
//
//  Created by Miran Hrupački on 04/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

struct MovieAPIListView {
    let id: Int
    let title: String
    let description: String
    let imageURL: String
    let year: String
//    let genreIds: String
    
    init(id: Int, title: String, description: String, imageURL: String, year: String){
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.year = year
//        self.genreIds = genres
    }
}
