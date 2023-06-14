//
//  DetailHistoryViewModel.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/21.
//

import Foundation
import Combine

class DetailHistoryViewModel: ObservableObject {
    
    // MARK: Retrieve historyActivity data from api server
    @Published var historyActivity: [DetailHistoryEntity] = []
    @Published var isLoading: Bool = false
    private var detailHistoryRequest = DetailHistoryRequest()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - retrieve historyActivity datas with xxAPI
    func fetchHistoryActivity(expenseId:Int, toCategory:String, yearMonth:Date) {
        isLoading = true
        detailHistoryRequest.fetch(expenseId:expenseId, toCategory:toCategory, yearMonth:yearMonth)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading = false
                }
            }, receiveValue: {response in
                self.historyActivity = response
                
            })
            .store(in: &cancellables)
        
        
    }
}
