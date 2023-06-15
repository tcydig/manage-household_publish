//
//  EditExpensesEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/27.
//

import Foundation

struct EditExpensesEntity: Codable {
    var expenses: [expenseEntity]
    var yearMonth: Date
}

struct expenseEntity: Codable,Identifiable {
    var id: Int
    var expenseId: Int
    var name: String
    var balance: Int
}
