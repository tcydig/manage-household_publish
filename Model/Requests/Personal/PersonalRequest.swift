//
//  PersonalRequest.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/11.
//

import Foundation
import Combine

class PersonalRequest: PersonalProtcol {

    private let scheme = "https"
    private let host = "{API Base Paht}"
    
    func fetchExpense(userId:Int) -> AnyPublisher<[PersonalEntity], Error> {
        
        guard let url = summaryApiComponents(path: "{path after base path including /}",userId: String(userId)).url else {
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
            .decode(type: [PersonalEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchHistory() -> AnyPublisher<[PersonalHistoryEntity], Error> {
        
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
            .decode(type: [PersonalHistoryEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}

// MARK: extension -> 継承の類似機能。既存のクラスに関数などを追加することができる
extension PersonalRequest {
    func summaryApiComponents(path: String,userId:String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "toCategory", value: "u"),
            URLQueryItem(name: "userId", value: userId)
        ]

        return components
    }
    
    func hisotoryApiComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "toCategory", value: "u"),
            URLQueryItem(name: "limit", value: "3")
        ]

        return components
    }
}
