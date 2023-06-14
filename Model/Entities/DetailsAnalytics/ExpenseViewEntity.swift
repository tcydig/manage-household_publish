//
//  ExpenseView.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation

struct ExpenseViewEntity: Codable,Identifiable {
    var id: Int
    var yearMonth: Date
    var totalBalance: Double
    var totalBalanceDifference: Double
    var animate: Bool = false
}

