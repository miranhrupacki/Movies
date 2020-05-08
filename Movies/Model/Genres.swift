//
//  Genres.swift
//  Movies
//
//  Created by Miran Hrupački on 08/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct Genres: Codable {
    let id: Int
    let name: String
}

public struct MovieGenres: Codable {
    let genres: [Genres]
}
