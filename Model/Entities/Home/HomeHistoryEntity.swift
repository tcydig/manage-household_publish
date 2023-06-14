//
//  HomeHistoryEntity.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation

struct HomeHistoryEntity: Codable {
    var history: [HomeHistoriesEntity]
    var yearMonth: Date
}

struct HomeHistoriesEntity: Codable,Identifiable {
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
