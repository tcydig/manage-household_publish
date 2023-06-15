//
//  PersonalEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation

struct HomeEntity: Codable {
    var expenses: [homeExpenseEntity]
    var yearMonth: Date
    var totalBalance: Int
    var totalBalanceDifference: Int
}

struct homeExpenseEntity: Codable,Identifiable {
    var id: Int
    var expenseId: Int
    var name: String
    var balance: Int
    var totalBalanceDifference: Int
}
