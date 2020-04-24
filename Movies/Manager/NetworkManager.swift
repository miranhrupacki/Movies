//
//  NetworkManager.swift
//  Movies
//
//  Created by Miran Hrupački on 04/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager{
    
    let parameters: Parameters = {
        var parameters = Parameters()
        parameters["api_key"] = "50385d4baddec9293929f01968c85235"
        return parameters
    }()
    
    func getData(url: String, _ completed: @escaping([MovieAPIList]?) -> Void){
        
        AF.request(url, parameters: parameters).validate().responseDecodable(of: Response<[MovieAPIList]?>.self, decoder: SerializationManager.jsonDecoder) { (movieResponse) in
            do {
                let response = try movieResponse.result.get()
                completed(response.results!)
            } catch let error{
                debugPrint("Error happed: ", error.localizedDescription)
                completed(nil)
            }
        }
    }
    
    func getMovieDirector(url: String, movieId: Int, _ completed: @escaping(Director?) -> Void){
        
        AF.request(url, parameters: parameters).validate().responseDecodable(of: Response<[Crew]>.self, decoder: SerializationManager.jsonDecoder) { (directorResponse) in
            do {
                let response = try directorResponse.result.get()
                let index = response.crew!.firstIndex(where: {
                    (crewMember) in crewMember.job == "Director"
                })
                completed ((index == nil) ? Director(name: " not found", movieId: movieId) : Director(name: response.crew![index!].name, movieId: movieId))
            } catch {
                debugPrint("Error happed: ", error.localizedDescription)
                completed(nil)
            }
        }
    }
    
    func getGenres(url: String,_ completed: @escaping([Genres]?) -> Void){
        AF.request(url, parameters: parameters).validate().responseDecodable(of: Response<[Genres]>.self, decoder: SerializationManager.jsonDecoder) { (genreResponse) in
            do {
                let response = try genreResponse.result.get()
                completed(response.genres)
            }catch {
                debugPrint("Error happened: ", error.localizedDescription)
                completed(nil)
            }
        }
    }
}
