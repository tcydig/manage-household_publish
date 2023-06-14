//
//  ArticleProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/21.
//

import Foundation

import Combine
 
protocol ArticleProtcol {
    func fetch() -> AnyPublisher<[Article], Error>
}
