//
//  PostEditExpensesEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation

struct PostEditExpensesEntity: Codable {
    var yearMonth: Date
    var expenseId: Int
    var userId: Int
    var status:String
    var balanceEntered:Int
    
    
    init(){
        yearMonth = Date()
        expenseId = 1
        userId = 1
        status = "A"
        balanceEntered = 0
    }
}
