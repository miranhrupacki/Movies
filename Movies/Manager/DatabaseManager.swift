//
//  DatabaseManager.swift
//  Movies
//
//  Created by Miran Hrupački on 08/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

struct DatabaseKeys{
    static let watched = "watched"
    static let favourite = "favourite"
}

class DatabaseManager {
    static let defaults = UserDefaults.standard
    
    static func isMovieWatched(with id: Int) -> Bool{
        guard let watchedIds = defaults.array(forKey: DatabaseKeys.watched) as? [Int] else {return false}
        return watchedIds.contains(id)
    }
    
    static func isMovieFovurited(with id: Int) -> Bool{
        guard let favouriteIds = defaults.array(forKey: DatabaseKeys.favourite) as? [Int] else {return false}
        return favouriteIds.contains(id)
    }
    
    static func watchedMovie(with id: Int){
        guard var watchedIds = defaults.array(forKey: DatabaseKeys.watched) as? [Int] else {
            defaults.set([id], forKey: DatabaseKeys.watched)
            return
        }
        watchedIds.append(id)
        defaults.set(watchedIds, forKey: DatabaseKeys.watched)
        defaults.synchronize()
    }
    
    static func favouritedMovie(with id: Int){
        guard var favouriteIds = defaults.array(forKey: DatabaseKeys.favourite) as? [Int] else {
            defaults.set([id], forKey: DatabaseKeys.favourite)
            return
        }
        favouriteIds.append(id)
        defaults.set(favouriteIds, forKey: DatabaseKeys.favourite)
        defaults.synchronize()
    }
    
    static func removeMovieFromWatched(with id: Int){
        guard var watchedIds = defaults.array(forKey: DatabaseKeys.watched) as? [Int] else {return}
        watchedIds.removeAll { (data) -> Bool in
            return data == id
        }
        defaults.set(watchedIds, forKey: DatabaseKeys.watched)
        defaults.synchronize()
    }
    
    static func removeMovieFromFavourite(with id: Int){
        guard var favouriteIds = defaults.array(forKey: DatabaseKeys.favourite) as? [Int] else {return}
        favouriteIds.removeAll { (data) -> Bool in
            return data == id
        }
        defaults.set(favouriteIds, forKey: DatabaseKeys.favourite)
        defaults.synchronize()
    }
}

