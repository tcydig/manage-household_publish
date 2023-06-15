//
//  DetailHistory.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/21.
//

import Foundation

struct DetailHistoryEntity: Codable, Identifiable {
    let id: Int
    let balance: Int
    let userId:Int
    let userName:String
    let toUserId:Int
    let toUserName:String
    let expenseId:Int
    let expenseName:String
    let status:String
    let category:String
    let updateDateTime:Date
}
