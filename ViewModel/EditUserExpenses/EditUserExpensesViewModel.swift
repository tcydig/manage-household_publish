//
//  EditUserExpensesViewModel.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/12.
//

import Foundation
import Combine

final class EditUserExpensesViewModel: ObservableObject {
    
    // MARK: Retrieve ditRule data from api server
    @Published var allMonthExpenses: [EditUserExpensesEntity] = []
    @Published var isLoading: Bool = false
    @Published var isSuccess = false
    @Published var currentMonthExpenses: [userExpenseEntity] = []
    @Published var yourBalance: Int = 0
    @Published var otherBalance: Int = 0
    @Published var selectedIndexOfCategory: Int = 0
    @Published var inputExpense: Int = 0
    @Published var currentDay: Date = Date()
    // MARK: - argument for status to edit
    @Published var isEditable = true
    private var editExpensesRequest = EditUserExpensesRequest()
    private var cancellables = Set<AnyCancellable>()
    private var selectingIndex:Int = 0
    // MARK: - retrieve editRule datas with xxAPI
    func fetchEditExpenses(userId:Int) {
        isLoading = true
        editExpensesRequest.fetch(userId:userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                    self.isLoading = false
                }
            }, receiveValue: {response in
                // store all months expenses from response
                self.allMonthExpenses = response
                self.extractCurrentExpenses(selectingMonth: self.currentDay)
                self.extractTotalBalance(index: self.selectedIndexOfCategory)
                
            })
            .store(in: &cancellables)
    }
    
    // MARK: - extract current rules from editRules
    func extractCurrentExpenses(selectingMonth : Date) {
        
        currentMonthExpenses.removeAll()
        
        let calender = Calendar(identifier: .gregorian)
        
        for (index, editExpenses) in allMonthExpenses.enumerated() {
            if calender.isDate(selectingMonth, equalTo: editExpenses.yearMonth, toGranularity: .month) {
                selectingIndex = index
                currentMonthExpenses = editExpenses.expenses

                self.updateStatusToEdit(selectingMonth: editExpenses.yearMonth)
                
            }
        }
        
        extractTotalBalance(index:self.selectedIndexOfCategory)
    }
    
    func updateStatusToEdit(selectingMonth: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        if formatter.string(from: selectingMonth) == formatter.string(from: Date()) {
            isEditable = true
        } else if formatter.string(from: selectingMonth) < formatter.string(from: Date()) {
            isEditable = false
        } else {
            isEditable = true
        }
    }
    
    // get totalBalance
    func extractTotalBalance(index: Int) {
        yourBalance = currentMonthExpenses[index].yourBalance
        otherBalance = currentMonthExpenses[index].otherBalance
        self.selectedIndexOfCategory = index
    }
    
    func pushExpense(categoryOfExpense:Int,balanceEntered:Int,categoryOfUpdate:String,userId:Int,toUserId:Int,yearMonth:Date) {
        isLoading = true
        inputExpense = 0
        currentDay = yearMonth

        var postEditUserExpensesEntity = PostEditUserExpensesEntity()
        postEditUserExpensesEntity.yearMonth = yearMonth
        postEditUserExpensesEntity.expenseId = categoryOfExpense
        postEditUserExpensesEntity.userId = userId
        postEditUserExpensesEntity.status = categoryOfUpdate
        postEditUserExpensesEntity.balanceEntered = balanceEntered
        postEditUserExpensesEntity.toUserId = toUserId


        editExpensesRequest.post(postEditExpensesEntity: postEditUserExpensesEntity)
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
                if response == 400 {
                    self.isSuccess = false
                } else {
                    self.isSuccess = true
                    
                }
                self.fetchEditExpenses(userId: userId)
            })
            .store(in: &cancellables)
    }
}
