//
//  PersonalEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/11.
//

import Foundation

struct PersonalEntity: Codable {
    var expenses: [personalExpenseEntity]
    var yearMonth: Date
    var totalBalance: Int
    var totalBalanceDifference: Int
}

struct personalExpenseEntity: Codable,Identifiable {
    var id: Int
    var expenseId: Int
    var name: String
    var balance: Int
    var totalBalanceDifference: Int
}
