//
//  HomeProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation
import Combine

protocol HomeProtcol {
    
    // 第一引数はPubliherによって公開される
    func fetchExpense() -> AnyPublisher<[HomeEntity], Error>
    
    // 第一引数はPubliherによって公開される
    func fetchHistory() -> AnyPublisher<[HomeHistoryEntity], Error>
}
