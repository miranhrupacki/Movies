//
//  NetworkManager.swift
//  Movies
//
//  Created by Miran Hrupački on 04/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation

class NetworkManager{
    let apiKey = "?api_key=50385d4baddec9293929f01968c85235"
    
    func getData(from url: String, _ completed: @escaping ([MovieAPIList]?) -> Void){
        guard let safeUrl = URL(string: url + apiKey) else {return}
        URLSession.shared.dataTask(with: safeUrl){ data, urlResponse, error in
            guard let safeData = data, error == nil, urlResponse != nil else {
                #warning("HANDLATI ERROR")
                completed(nil)
                return
            }
            do{
                if let decodedObject: Response<[MovieAPIList]> = SerializationManager.parseData(jsonData: safeData){
                    DispatchQueue.main.async {
                        completed(decodedObject.results)
                    }
                }else{
                    print("ERROR: palo parsanje")
                        completed(nil)
                }
            }catch let error{
                print("Error: \(error.localizedDescription)")
                completed(nil)
            }
        }.resume()
    }
    
    
    func getMovieDirector(from url: String, movieId: Int, _ completed: @escaping(Director?) -> Void){
        guard let safeUrl = URL(string: url + apiKey) else{
            DispatchQueue.main.async {
                completed(nil)
            }
            return
        }
        URLSession.shared.dataTask(with: safeUrl){ data, urlResponse, error in
            guard let safeData = data, error == nil, urlResponse != nil else {
                DispatchQueue.main.async {
                    completed(nil)
                }
                return
            }
            if let decodedObject: Response<[Crew]> = SerializationManager.parseData(jsonData: safeData){
                let index = decodedObject.crew!.firstIndex(where: {
                    (crewMember) in crewMember.job == "Director"
                })!
                DispatchQueue.main.async {
                    completed(Director(name: decodedObject.crew![index].name, movieId: movieId))
                }
            }
            else {
                DispatchQueue.main.async {
                    completed(nil)
                }
            }

        }.resume()
    }
    
        func getGenres(from url: String,_ completed: @escaping([Genres]?) -> Void){
            guard let safeUrl = URL(string: url + apiKey) else{
                DispatchQueue.main.async {
                    completed(nil)
                }
                return
            }
            URLSession.shared.dataTask(with: safeUrl){ data, urlResponse, error in
                guard let safeData = data, error == nil, urlResponse != nil else {
                    DispatchQueue.main.async {
                        completed(nil)
                    }
                    return
                }
                    if let decodedObject: Response<[Genres]> = SerializationManager.parseData(jsonData: safeData){
                        DispatchQueue.main.async {
                            completed(decodedObject.genres)
                        }
                    }
                    else {
                        print("ERROR: palo parsanje")
                        DispatchQueue.main.async {
                            completed(nil)
                        }
                    }
    
            }.resume()
        }
}
