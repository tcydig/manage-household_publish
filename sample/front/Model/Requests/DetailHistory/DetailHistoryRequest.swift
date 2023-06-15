//
//  DetailHistoryRequest.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/21.
//

import Foundation
import Combine

class DetailHistoryRequest: DetailHistoryProtcol {
    
    private let scheme = "https"
    private let host = "{API Base Paht}"
    
    func fetch(expenseId:Int, toCategory:String, yearMonth:Date) -> AnyPublisher<[DetailHistoryEntity], Error> {
        let dateFormatter_request = DateFormatter()
        dateFormatter_request.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yearMonth_string = dateFormatter_request.string(from: yearMonth)
        
        guard let url = apiComponents(path: "{path after base path including /}",toCategory: toCategory,yearMonth:yearMonth_string,expenseId:String(expenseId)).url else {
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
            .decode(type: [DetailHistoryEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

// MARK: extension -> 継承の類似機能。既存のクラスに関数などを追加することができる
extension DetailHistoryRequest {
    
    func apiComponents(path: String,toCategory: String,yearMonth: String,expenseId: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "toCategory", value: toCategory),
            URLQueryItem(name: "limit", value: "0"),
            URLQueryItem(name: "yearMonth", value: yearMonth),
            URLQueryItem(name: "expenseId", value: expenseId)
        ]

        return components
    }
}
