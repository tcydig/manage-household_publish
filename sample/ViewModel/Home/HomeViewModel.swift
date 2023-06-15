//
//  HomePersonalViewModel.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/28.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private var homeRequest = HomeRequest()
    // MARK: expenseView
    @Published var allExpenseView: [HomeEntity] = []
    @Published var expenseView: [homeExpenseEntity] = []
    @Published var isLoading: Bool = false
    @Published var totalBalance: Int = 0
    @Published var beforeDifferenceTotalBalance: Int = 0
    @Published var beforeDifferenceBalance: Int = 0
    private var cancellablesExpense = Set<AnyCancellable>()
    // MARK: History View
    @Published var homeHistoryList: [HomeHistoryEntity] = []
    @Published var homeHistoriesList: [HomeHistoriesEntity] = []
    private var selectingIndex:Int = 0
    private var cancellablesHistory = Set<AnyCancellable>()
    
    // MARK: - retrieve editRule datas with xxAPI
    func fetchExpenseView() {
        isLoading = true
        homeRequest.fetchExpense()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Retrive expense api finished")
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                }
            }, receiveValue: {response in
                self.allExpenseView = response
                self.extractCurrentExpense(selectingMonth: Date())
            })
            .store(in: &cancellablesExpense)
        fetchHistory()
        
    }
    
    // MARK: - extract current rules from editRules
    func extractCurrentExpense(selectingMonth : Date) {
        
        expenseView.removeAll()
        
        let calender = Calendar(identifier: .gregorian)
        
        for (index, expenseView) in allExpenseView.enumerated() {
            if calender.isDate(selectingMonth, equalTo: expenseView.yearMonth, toGranularity: .month) {
                selectingIndex = index
                self.totalBalance = expenseView.totalBalance
                self.beforeDifferenceTotalBalance = expenseView.totalBalanceDifference
                self.expenseView = expenseView.expenses
            }
        }
    }
    
    func fetchHistory() {
        homeRequest.fetchHistory()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Retrive expenseHistory api finished")
                    self.isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                    
                    self.isLoading = false
                }
            }, receiveValue: {response in
                self.homeHistoryList = response
                self.extractCurrentHistory(selectingMonth: Date())
                print(response)
            })
            .store(in: &cancellablesHistory)
    }
    
    // MARK: - extract current rules from editRules
    func extractCurrentHistory(selectingMonth : Date) {
        
        homeHistoriesList.removeAll()
        
        let calender = Calendar(identifier: .gregorian)
        
        for histories in homeHistoryList {
            if calender.isDate(selectingMonth, equalTo: histories.yearMonth, toGranularity: .month) {
                self.homeHistoriesList = histories.history
            }
        }
    }
}
