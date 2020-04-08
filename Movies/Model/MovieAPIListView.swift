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
    var watched: Bool
    var favourite: Bool
//    let genreIds: String
    
    init(id: Int, title: String, imageURL: String, description: String, year: String, watched: Bool, favourite: Bool){
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.year = year
        self.watched = watched
        self.favourite = favourite
//        self.genreIds = genreIds
    }
}
