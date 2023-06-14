//
//  HomeRequest.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation
import Combine

class HomeRequest: HomeProtcol {
    private let scheme = "https"
    private let host = "{API Base Paht}"
    
    func fetchExpense() -> AnyPublisher<[HomeEntity], Error> {
        
        guard let url = summaryApiComponents(path: "{path after base path including /}").url else {
            let error = RequestError.parse(description: "wrong request url")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        // MARK: URLSession.shared -> protcol to connect outside with singleton
        // MARK: dataTaskPublisher -> return publisher that wrap url
        return URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map({ $0.data })
            .decode(type: [HomeEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchHistory() -> AnyPublisher<[HomeHistoryEntity], Error> {
        
        guard let url = hisotoryApiComponents(path: "{path after base path including /}").url else {
            let error = RequestError.parse(description: "wrong request url")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        // MARK: URLSession.shared -> protcol to connect outside with singleton
        // MARK: dataTaskPublisher -> return publisher that wrap url
        return URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map({ $0.data })
            .decode(type: [HomeHistoryEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}

// MARK: extension -> 継承の類似機能。既存のクラスに関数などを追加することができる
extension HomeRequest {
    func summaryApiComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "toCategory", value: "h")
        ]

        return components
    }
    
    func hisotoryApiComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "toCategory", value: "h"),
            URLQueryItem(name: "limit", value: "3")
        ]

        return components
    }
}
