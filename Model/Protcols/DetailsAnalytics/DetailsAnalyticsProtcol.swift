//
//  DetailsAnalyticsProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation
import Combine

protocol DetailsAnalyticsProtcol {
    
    // 第一引数はPubliherによって公開される
    func fetchExpense(expenseId: Int,pageCategory: String,userId: Int) -> AnyPublisher<[ExpenseViewEntity], Error>
    
    // 第一引数はPubliherによって公開される
    func fetchHistory(toCategory: String,yearMonth: Date,expenseId: Int,pageCategory:String) -> AnyPublisher<[DetailsAnalyticsHomeHistoryEntity], Error>
}
