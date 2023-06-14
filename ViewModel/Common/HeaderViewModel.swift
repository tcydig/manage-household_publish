//
//  HeaderViewModel.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/11.
//

import SwiftUI

class HeaderViewModel: ObservableObject {
    @Published var userId  = 2
    static var shared = HeaderViewModel()
    
    func Change(selectedUserId:Int){
        if userId != selectedUserId{
            print(selectedUserId)
            userId = selectedUserId
        }
    }
}
