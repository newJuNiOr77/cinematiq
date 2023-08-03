//
//  APICaller.swift
//  cinematiq
//
//  Created by Юрий on 30.07.2023.
//

// in RU use VPN (Finland, Nethelands, Latvia,.. - Ok)
// my API-key:   982ff408ebe1211df88fe23850a89542



import UIKit

struct Constants {
    static let API_KEY =  "982ff408ebe1211df88fe23850a89542"
    static let baseURL = "https://api.themoviedb.org"
    
    static let  youTubeAPI_KEY = "AIzaSyDWXqMsJc_WggOnCgkUoCVkl5LHXj-fQX0"
    static  let baseYouTubeURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
    
}

class APICaller {
    static let shared = APICaller()
    

    
    func getTrendingMovies(completion: @escaping  (Result< [Title],  Error >  ) -> Void )  {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)&language=ru-RU")    else {return}

       let task = URLSession.shared.dataTask(with: URLRequest(url: url))  {data, _ , error in
            guard let data = data, error == nil  else{
                return
            }
            do {
                let  result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    
    func getTopRatedTvs(completion: @escaping ( Result<[Title], Error> ) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/tv/top_rated?api_key=\(Constants.API_KEY)&language=ru-RU")    else {return}

        URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in
            guard let data = data, error ==  nil else {
                return
            }
            do  {
                let result = try JSONDecoder().decode(TitleResponse.self,  from: data)
                completion(.success(result.results))
            }
            catch{
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    
    func getUpcomingMovies(completion:  @escaping (Result < [Title], Error>) -> Void)  {

        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=ru-RU")  else {return}
        URLSession.shared.dataTask(with:URLRequest(url: url)) { data, _, error in
            guard let data = data, error ==  nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }


    func getTopRated(completion:  @escaping (Result < [Title], Error>) -> Void)  {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=ru-RU")  else {return}
        URLSession.shared.dataTask(with:URLRequest(url: url)) { data, _, error in
            guard let data = data, error ==  nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }.resume()
    }

    func getDiscoveredMovies (completion:  @escaping (Result <[Title], Error>) -> Void)   {
        guard let url = URL(string:  "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=ru-RU&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")  else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil   else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }.resume()
    }


    // --------------------------------------------------------------
    
    func search(with query: String, completion:  @escaping (Result <[Title], Error>) -> Void)   {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }

        guard let url = URL(string:  "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&language=ru-RU&query=\(query)")   else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil   else {
                return
            }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }.resume()
    }


    
    // MARK: - for youTube trailers:
    
    func getMovie (with query: String, completion:  @escaping (Result < VideoElement, Error>) -> Void)   {

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)  else {
            return
        }
        guard let url = URL(string: "\(Constants.baseYouTubeURL)q=\(query)&key=\(Constants.youTubeAPI_KEY)")   else {
            return
        }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil   else {
                return
            }
            do {
                let result = try  JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

