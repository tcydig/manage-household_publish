//
//  EditExpensesRequest.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/27.
//

import Foundation
import Combine

class EditExpensesRequest: EditExpensesProtcol {
    
    private let scheme = "https"
    private let host = "{API Base Paht}"
    
    func fetch() -> AnyPublisher<[EditExpensesEntity], Error> {
        
        guard let url = getExpenseApiComponents(path: "{path after base path including /}").url else {
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
            .decode(type: [EditExpensesEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func post(postEditExpensesEntity: PostEditExpensesEntity) -> AnyPublisher<Int, Error> {
        guard let url = postExpenseApiComponents(path: "{path after base path including /}").url else {
            let error = RequestError.parse(description: "wrong request url")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(postEditExpensesEntity)

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap{ element -> Int in

                guard let response =
                        element.response as? HTTPURLResponse else {
                    return 400
                }
                // HTTPステータスコードのチェック
                guard 200 ..< 300 ~= response.statusCode else {
                    return 400
                }

                return response.statusCode
            }
            .eraseToAnyPublisher()
    }
}

// MARK: extension -> 継承の類似機能。既存のクラスに関数などを追加することができる
extension EditExpensesRequest {
    
    func getExpenseApiComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        return components
    }
    
    func postExpenseApiComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        return components
    }
}
