//
//  MovieAPIList.swift
//  Movies
//
//  Created by Miran Hrupački on 04/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct MovieAPIList: Codable{
    let id: Int
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let originalTitle: String
    let originalLanguage: String
    let posterPath: String?
    let title: String
    let adult: Bool
    let backdropPath: String?
    let video: Bool
    let voteAverage: Float
}
