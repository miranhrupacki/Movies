//
//  UserInteraction.swift
//  Movies
//
//  Created by Miran Hrupački on 08/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

protocol UserInteraction: class {
    func watchedMoviePressed(with id: Int)
    func favouriteMoviePressed(with id: Int)
}
