//
//  EditUserExpensesEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/12.
//

import Foundation

struct EditUserExpensesEntity: Codable {
    var expenses: [userExpenseEntity]
    var yearMonth: Date
}

struct userExpenseEntity: Codable,Identifiable {
    var id: Int
    var expenseId: Int
    var name: String
    var yourBalance: Int
    var otherBalance: Int
}
