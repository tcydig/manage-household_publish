//
//  PersonalProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/11.
//

import Foundation
import Combine

protocol PersonalProtcol {
    
    // 第一引数はPubliherによって公開される
    func fetchExpense(userId:Int) -> AnyPublisher<[PersonalEntity], Error>
    
    // 第一引数はPubliherによって公開される
    func fetchHistory() -> AnyPublisher<[PersonalHistoryEntity], Error>
}
