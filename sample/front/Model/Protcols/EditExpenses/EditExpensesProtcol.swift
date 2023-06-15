//
//  EditExpensesProtcol.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/27.
//

import Foundation
import Combine

protocol EditExpensesProtcol {
    
    // 第一引数はPubliherによって公開される
    func fetch() -> AnyPublisher<[EditExpensesEntity], Error>
    
    // 第二引数はPubliherによって公開される
    func post(postEditExpensesEntity: PostEditExpensesEntity) -> AnyPublisher<Int, Error>
}
