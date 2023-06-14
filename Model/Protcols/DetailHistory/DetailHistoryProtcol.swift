//
//  DetailHistoryProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/21.
//

import Foundation
import Combine

protocol DetailHistoryProtcol {
    
    // 第一引数はPubliherによって公開される
    func fetch(expenseId:Int, toCategory:String, yearMonth:Date) -> AnyPublisher<[DetailHistoryEntity], Error>
}
