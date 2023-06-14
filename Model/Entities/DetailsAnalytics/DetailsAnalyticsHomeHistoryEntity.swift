//
//  DetailsAnalyticsHomeHistoryEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation

struct DetailsAnalyticsHomeHistoryEntity: Codable,Identifiable {
    var id:Int
    var userId: Int
    var userName: String
    var toUserId: Int
    var toUserName: String
    var expenseId: Int
    var expenseName: String
    var updateDateTime: Date
    var balance: Int
    var category: String
    var status: String
}
