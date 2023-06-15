//
//  PostEditExpensesEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/12.
//

import Foundation

struct PostEditUserExpensesEntity: Codable {
    var yearMonth: Date
    var expenseId: Int
    var userId: Int
    var status:String
    var balanceEntered:Int
    var toUserId:Int
    
    init(){
        yearMonth = Date()
        expenseId = 0
        userId = 1
        status = "A"
        balanceEntered = 0
        toUserId = 1
    }
}
