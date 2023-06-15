//
//  DetailsAnalyticsRequest.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation
import Combine

class DetailsAnalyticsRequest: DetailsAnalyticsProtcol {

    private let scheme = "https"
    private let host = "{API Base Paht}"
    
    func fetchExpense(expenseId: Int,pageCategory: String,userId: Int) -> AnyPublisher<[ExpenseViewEntity], Error> {
        
        guard let url = analyticsApiComponents(path: "{path after base path including /}",expenseId: String(expenseId),pageCategory: pageCategory,userId: String(userId)).url else {
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
            .decode(type: [ExpenseViewEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchHistory(toCategory: String,yearMonth: Date,expenseId: Int,pageCategory:String) -> AnyPublisher<[DetailsAnalyticsHomeHistoryEntity], Error> {
        
        let dateFormatter_request = DateFormatter()
        dateFormatter_request.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yearMonth_string = dateFormatter_request.string(from: yearMonth)
        
        guard let url = historyApiComponents(path: "{path after base path including /}",toCategory: toCategory,yearMonth: yearMonth_string,expenseId: String(expenseId),pageCategory:pageCategory).url else {
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
            .decode(type: [DetailsAnalyticsHomeHistoryEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}

// MARK: extension -> 継承の類似機能。既存のクラスに関数などを追加することができる
extension DetailsAnalyticsRequest {
    
    func analyticsApiComponents(path: String,expenseId: String,pageCategory: String,userId: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "expenseId", value: expenseId),
            URLQueryItem(name: "pageCategory", value: pageCategory),
            URLQueryItem(name: "userId", value: userId)
        ]
        return components
    }
    
    func historyApiComponents(path: String,toCategory: String,yearMonth: String,expenseId: String,pageCategory: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "toCategory", value: toCategory),
            URLQueryItem(name: "limit", value: "3"),
            URLQueryItem(name: "yearMonth", value: yearMonth),
            URLQueryItem(name: "expenseId", value: expenseId),
            URLQueryItem(name: "pageCategory", value: pageCategory)
        ]

        return components
    }
}
