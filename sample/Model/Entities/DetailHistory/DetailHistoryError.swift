//
//  DetailHistoryError.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/21.
//

import Foundation

enum RequestError: Error {
    case parse(description: String)
    case network(description: String)
}
