//
//  EditeExpensesProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/12.
//

import Foundation
import Combine

protocol EditeUserExpensesProtcol {
    
    // 第一引数はPubliherによって公開される
    func fetch(userId:Int) -> AnyPublisher<[EditUserExpensesEntity], Error>
    
    // 第二引数はPubliherによって公開される
    func post(postEditExpensesEntity: PostEditUserExpensesEntity) -> AnyPublisher<Int, Error>
}
