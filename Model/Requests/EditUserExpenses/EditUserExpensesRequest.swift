//
//  EditUserExpensesRequest.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/12.
//

import Foundation
import Combine

class EditUserExpensesRequest: EditeUserExpensesProtcol {

    private let scheme = "https"
    private let host = "{API Base Paht}"
    
    func fetch(userId:Int) -> AnyPublisher<[EditUserExpensesEntity], Error> {
        
        guard let url = userExpenseApiComponents(path: "{path after base path including /}",userId: String(userId)).url else {
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
            .decode(type: [EditUserExpensesEntity].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func post(postEditExpensesEntity: PostEditUserExpensesEntity) -> AnyPublisher<Int, Error> {
        
        guard let url = postUserExpenseApiComponents(path: "{path after base path including /}").url else {
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
        
        print(postEditExpensesEntity)

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
extension EditUserExpensesRequest {
    
    func userExpenseApiComponents(path: String,userId:String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]

        return components
    }
    
    func postUserExpenseApiComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        return components
    }
}
