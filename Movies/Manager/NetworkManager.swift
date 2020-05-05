//
//  NetworkManager.swift
//  Movies
//
//  Created by Miran Hrupački on 04/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class NetworkManager{
    
    enum NetworkError: Error {
        case error
    }
    
    let parameters: Parameters = {
        var parameters = Parameters()
        parameters["api_key"] = "50385d4baddec9293929f01968c85235"
        return parameters
    }()
    
    func getData(url: String) -> Observable<[MovieAPIList]> {
        return Observable.create { observer in
            AF.request(url, parameters: self.parameters).validate().responseDecodable(of: Response<[MovieAPIList]>.self, decoder: SerializationManager.jsonDecoder) { (movieResponse) in
                switch movieResponse.result {
                case .success:
                    do {
                        let response = try movieResponse.result.get()
                        guard let safeResults = response.results else {
                            observer.onError(NetworkError.error)
                            return
                        }
                        observer.onNext(safeResults)
                        observer.onCompleted()
                    }
                    catch let error{
                        debugPrint("Error happed: ", error.localizedDescription)
                    }
                case.failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMovieDirector(url: String, movieId: Int) -> Observable<Director>{
        return Observable.create { observer in
            AF.request(url, parameters: self.parameters).validate().responseDecodable(of: Response<[Crew]>.self, decoder: SerializationManager.jsonDecoder) { (directorResponse) in
                switch directorResponse.result {
                case .success:
                    do {
                        let response = try directorResponse.result.get()
                        let index = response.crew!.firstIndex(where: {
                            (crewMember) in crewMember.job == "Director"
                        })
                        observer.onNext((index == nil) ? Director(name: " not found", movieId: movieId) : Director(name: response.crew![index!].name, movieId: movieId))
                        observer.onCompleted()
                    }
                    catch {
                        debugPrint("Error happed: ", error.localizedDescription)
                    }
                case .failure (let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getGenres(url: String) -> Observable<[Genres]>{
        return Observable.create { observer in
            AF.request(url, parameters: self.parameters).validate().responseDecodable(of: Response<[Genres]>.self, decoder: SerializationManager.jsonDecoder) { (genreResponse) in
                switch genreResponse.result {
                case .success:
                    do {
                        let response = try genreResponse.result.get()
                        guard let safeGenres = response.results else {
                            observer.onError(NetworkError.error)
                            return
                        }
                        observer.onNext(safeGenres)
                        observer.onCompleted()
                    }
                    catch let error{
                        debugPrint("Error happened: ", error.localizedDescription)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
