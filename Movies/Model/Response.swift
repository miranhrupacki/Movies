//
//  Response.swift
//  Movies
//
//  Created by Miran Hrupački on 04/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

public struct Response<T: Codable>: Codable {
    let results: T?
//    let genres: T?
    let crew: T?
}
