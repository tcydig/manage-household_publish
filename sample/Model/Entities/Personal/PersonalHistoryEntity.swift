//
//  PersonalHistoryEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/11.
//

import Foundation

struct PersonalHistoryEntity: Codable {
    var history: [PersonalHistoriesEntity]
    var yearMonth: Date
}

struct PersonalHistoriesEntity: Codable,Identifiable {
    var id:Int
    var balance:Int
    var userId:Int
    var userName:String
    var toUserId:Int
    var toUserName:String
    var expenseId:Int
    var expenseName:String
    var status:String
    var category:String
    var updateDateTime:Date
}
