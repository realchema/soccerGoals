//
//  DataInfoUtility.swift
//  SoccerGoal
//
//  Created by Jose M Arguinzzones on 2021-05-13.
//

import Foundation
import UIKit

struct DataInfoUtility {
    
    static let shared = DataInfoUtility()
     let urlSession = URLSession.shared
     let apiKey = "881ee6d7a3db4094a6d9ac561c25962a"
     let baseURL = "https://api.football-data.org/v2/"
    
     let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
     init() {}
    
     func startEndDateFilter(isUpcoming: Bool) -> (String, String) {
        let today = Date()
        let tenDays = today.addingTimeInterval(86400 * (isUpcoming ? 10 : -10))
        
        let todayText = DataInfoUtility.dateFormatter.string(from: today)
        let tenDaysText = DataInfoUtility.dateFormatter.string(from: tenDays)
        return isUpcoming ? (todayText, tenDaysText) : (tenDaysText, todayText)
    }
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let dateFormatterHours: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func fetchLatestMatches(competitionId: Int, completion: @escaping(Result<[Match], Error>) -> ()) {
        let (tenDaysAgoText, todayText) = startEndDateFilter(isUpcoming: false)
        
        let url = baseURL + "/matches?status=FINISHED&competitions=\(competitionId)&dateFrom=\(tenDaysAgoText)&dateTo=\(todayText)"
        let urlRequest = URLRequest(url: URL(string: url)!)
        fetchData(request: urlRequest) { (result: Result<MatchResponse, Error>) in
            switch result {
            case .success(let response):
                latestMatches = response.matches
                completion(.success(response.matches))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUpcomingMatches(competitionId: Int, completion: @escaping(Result<[Match], Error>) -> ()) {
        let (tenDaysAgoText, todayText) = startEndDateFilter(isUpcoming: true)
        
        let url = baseURL + "/matches?status=SCHEDULED&competitions=\(competitionId)&dateFrom=\(tenDaysAgoText)&dateTo=\(todayText)"
        let urlRequest = URLRequest(url: URL(string: url)!)

        fetchData(request: urlRequest) { (result: Result<MatchResponse, Error>) in
            switch result {
            case .success(let response):
                upcommingMatches = response.matches
                completion(.success(response.matches))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchLatestStandings(competitionId: Int, completion: @escaping(Result<[TeamStandingTable], Error>) -> ()) {
        let url = baseURL + "/competitions/\(competitionId)/standings"
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        fetchData(request: urlRequest) { (result: Result<StandingResponse, Error>) in
            switch result {
            case .success(let response):
                if let standing = response.standings?.first {
                    completion(.success(standing.table))
                    teamStandingTable = standing.table
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not found"])))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeamDetail(teamId: Int, completion: @escaping(Result<Team, Error>) -> ()) {
        let url = baseURL + "/teams/\(teamId)"
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        fetchData(request: urlRequest, completion: completion)
    }
    
    func fetchMatchDetail(matchId: Int, completion: @escaping(Result<MatchDetail, Error>) -> ()) {
        let url = baseURL + "/matches/\(matchId)"
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        fetchData(request: urlRequest) { (result: Result<MatchDetailResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.match))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchData<D: Decodable>(request: URLRequest, completion: @escaping(Result<D, Error>) -> ()) {
        var urlRequest = request
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"])
                completion(.failure(error))
                return
            }
            
            do {
                let d = try self.jsonDecoder.decode(D.self, from: data)
                completion(.success(d))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    enum MatchInfoError: Error, LocalizedError {
        case imageDataMissing
    }

    func fetchImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let baseURL = URL(string:  url)!
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            urlComponents?.scheme = "https"
        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(MatchInfoError.imageDataMissing))
            }
        }

        task.resume()
    }
    
    //////
    
    
    
    
}


struct StandingResponse: Decodable {
    
    var standings: [Standing]?
    
    
}

//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}


