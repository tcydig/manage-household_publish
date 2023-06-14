//
//  DetailsAnalyticsModel.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation
import Combine

class DetailsAnalyticsViewModel: ObservableObject {
    
    private var detailsAnalyticsRequest = DetailsAnalyticsRequest()
    // MARK: expenseView
    @Published var expenseView: [ExpenseViewEntity] = []
    @Published var isLoading: Bool = false
    @Published var totalBalance: Int = 0
    @Published var totalBalanceDifference: Int = 0
    private var cancellablesExpense = Set<AnyCancellable>()
    // MARK: History View
    @Published var historyList: [DetailsAnalyticsHomeHistoryEntity] = []
    private var cancellablesHistory = Set<AnyCancellable>()
    
    // MARK: - retrieve editRule datas with xxAPI
    func fetchExpenseView(expenseId: Int,pageCategory: String,userId: Int,yearMonth: Date) {
        isLoading = true
        detailsAnalyticsRequest.fetchExpense(expenseId: expenseId,pageCategory: pageCategory,userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Retrive expenseView api finished")
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                }
            }, receiveValue: {response in
                self.expenseView = response
                self.updateTotalBalance(index:6)
                self.updateBeforeDifferenceBalance(index:6)
                print(self.expenseView)
            })
            .store(in: &cancellablesExpense)
        fetchHistory(toCategory: "e",yearMonth: yearMonth,expenseId: expenseId,pageCategory:pageCategory)
    }
    
    func fetchHistory(toCategory: String,yearMonth: Date,expenseId: Int,pageCategory:String) {
        isLoading = true
        detailsAnalyticsRequest.fetchHistory(toCategory: toCategory,yearMonth: yearMonth,expenseId: expenseId,pageCategory:pageCategory)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Retrive expenseView api finished")
                    self.isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                    
                    self.isLoading = false
                }
            }, receiveValue: {response in
                self.historyList = response
                print(self.historyList)
            })
            .store(in: &cancellablesHistory)
    }
    
    func updateTotalBalance(index: Int) {
        self.totalBalance = Int(expenseView[index].totalBalance)
    }
    
    func updateBeforeDifferenceBalance(index: Int) {
        self.totalBalanceDifference = Int(expenseView[index].totalBalanceDifference)
    }
}

