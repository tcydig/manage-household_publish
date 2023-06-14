//
//  Home.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/10.
//

import SwiftUI

struct Home: View {
    
    // viewModel class
    @ObservedObject var viewModel = HomeViewModel()
    // local variable
    @State var currentDay: Date = Date()
    // animation flag
    @State var showViews: [Bool] = Array(repeating: false, count: 5)
    // list for horizontal scrolling menu of months
    @State var months: [Date] = []
    // trigger valiable to move detail histor page
    @State private var historyClicked: Bool = false
    // trigger valiable to move expense analytics page
    @State private var expenseClicked: Bool = false
    // valiable to store expenseId you clicked(to expense analytics page)
    @State var selectingExpenseId: Int = 0
    // valiable to store expenseName you clicked(to expense analytics page)
    @State var selectingExpensName: String = ""
    
    var body: some View {
        VStack(spacing: 20){
            // header
            HStack{
                Text("Home")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .foregroundColor(.white)
            .opacity(showViews[0] ? 1 : 0)
            .offset(y: showViews[0] ? 0 : 200)
            
            // horizontal scrolling menu of months
            ScrollView([.horizontal]){
                // scrolling date header
                HStack(spacing: 10){
                    ForEach(months, id: \.self) {date in
                        Text(extractYearMonth(date:date))
                            .fontWeight(isSameMonth(date: currentDay, date2: date) ? .bold: .semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,isSameMonth(date: currentDay, date2: date) ? 6: 0)
                            .padding(.horizontal,isSameMonth(date: currentDay, date2: date) ? 12: 0)
                            .frame(width: isSameMonth(date: currentDay, date2: date) ? 140 : nil)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .environment(\.colorScheme, .light)
                                    .opacity(isSameMonth(date: currentDay, date2: date) ? 0.8 : 0)
                            )
                            .onTapGesture {
                                withAnimation{
                                    currentDay = date
                                    viewModel.extractCurrentExpense(selectingMonth: currentDay)
                                    viewModel.extractCurrentHistory(selectingMonth: currentDay)
                                }
                            }
                    }
                }
            }
            .padding(.top,10)
            .opacity(showViews[1] ? 1 : 0)
            .offset(y: showViews[1] ? 0 : 250)
            
            if viewModel.isLoading {
                // if api is not finished, show indicator
                ActivityIndicator()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Spent")
                        .fontWeight(.semibold)
                    HStack {
                        Text("\(viewModel.totalBalance)")
                            .font(.system(size: 45, weight: .bold))
                        if viewModel.beforeDifferenceTotalBalance < 0 {
                            let monthOverMonth = viewModel.beforeDifferenceTotalBalance  * -1
                            Text("- \(String.localizedStringWithFormat("%d", monthOverMonth))")
                                .font(.system(size: 25, weight: .bold))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(.top,25)
                        } else if viewModel.beforeDifferenceTotalBalance > 0 {
                            Text("+ \(String.localizedStringWithFormat("%d", viewModel.beforeDifferenceTotalBalance))")
                                .font(.system(size: 25, weight: .bold))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding(.top,25)
                        } else {
                            Text("± 0")
                                .font(.system(size: 25, weight: .bold))
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .padding(.top,25)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical,15)
                
                // DetailExpense Content
                VStack(spacing: 15) {
                    ForEach(viewModel.expenseView) { list in
                        Text(list.name)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(String.localizedStringWithFormat("%d", list.balance))
                                .font(.title3)
                                .fontWeight(.bold)
                            .padding(.top, -10)
                            
                            if list.totalBalanceDifference < 0 {
                                let reversalNum = list.totalBalanceDifference  * -1
                                Text("- \(String.localizedStringWithFormat("%d", reversalNum))")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else if list.totalBalanceDifference > 0 {
                                Text("+ \(String.localizedStringWithFormat("%d", list.totalBalanceDifference))")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            } else {
                                Text("± 0")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                                
                            Spacer()
                            
                            Button {
                                expenseClicked.toggle()
                                self.selectingExpensName = list.name
                                self.selectingExpenseId = list.expenseId
                            } label: {
                                Text("More Detail")
                            }
                        }
                        Divider()
                    }
                }
                .padding(.horizontal,20)
                .padding(.vertical,25)
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .navigationDestination(isPresented: $expenseClicked, destination: {
                    DetailsAnalyticsHomeView(expenseId: selectingExpenseId, expenseName: selectingExpensName, pageCategory: "h", userId: 0)
                })
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Recent History")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !viewModel.homeHistoriesList.isEmpty {
                            Button {
                                historyClicked.toggle()
                            } label: {
                                Text("More Detail")
                                    .padding(.trailing, 30)
                                    .padding(.top, 15)
                                    .padding(.bottom, -5)
                                    .foregroundColor(.green)
                            }
                        }

                    }
                    if viewModel.homeHistoriesList.isEmpty {
                        Text("History is nothing in this month")
                            .padding(.top, 10)
                            .font(.title2)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.homeHistoriesList) { list in
                            
                            HStack {
                                VStack{
                                        Text(list.expenseName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("user: \(list.userName)")
                                            .fontWeight(.medium)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.gray)

                                        Text("Date: \(list.updateDateTime,style: .date)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.gray)
                                }
                                
                                VStack{
                                    Text("¥ \(String.localizedStringWithFormat("%d", list.balance))")
                                        .font(.system(size: 20, weight: .bold))
                                    
                                    if list.status == "A" {
                                        Text("ADD")
                                            .foregroundColor(.green)
                                            .frame(width: 50, height: 40)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.green, lineWidth: 1)
                                            )
                                            .shadow(color: Color.green, radius: 20, x: 0, y: 0)
                                            .shadow(color: Color.green.opacity(0.7), radius: 1, x: 0, y: 0)
                                            .compositingGroup()
                                            .shadow(color: .green, radius: 3, x: 2, y: 3)
                                    } else if list.status == "D" {
                                        Text("DELETE")
                                            .foregroundColor(.red)
                                            .frame(width: 90, height: 40)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.red, lineWidth: 1)
                                            )
                                            .shadow(color: Color.red, radius: 20, x: 0, y: 0)
                                            .shadow(color: Color.red.opacity(0.7), radius: 1, x: 0, y: 0)
                                            .compositingGroup()
                                            .shadow(color: .red, radius: 3, x: 2, y: 3)
                                    }
                                }
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,10)
                            .background{
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            }
                        }
                    }
                    
                }
                .navigationDestination(isPresented: $historyClicked, destination: {
                    DetailHistoryView(expenseId: 0, toCategory: "h", yearMonth: currentDay)
                })
            }
            

        }
        .padding()
        .onAppear(perform: extractMonths)
        .onAppear(perform: animateViews)
        .onAppear {
            viewModel.fetchExpenseView()
            currentDay = Date()
        }
    }
    
    func animateViews(){
        withAnimation(.easeInOut){
            showViews[0] = true
        }
        withAnimation(.easeInOut.delay(0.1)){
            showViews[1] = true
        }
        
    }
    
    func extractMonths(){
        
        months.removeAll()
        
        // obtain today
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()

        // obtain year and month from three months ago to three months later
        (-3..<4).forEach{month in
            if let month = calendar.date(byAdding: .month, value: month, to: today){
                months.append(month)
            }
        }
    }
    
    /*
     return true if given date is today, Otherewise false.
     */
    func extractYearMonth(date: Date)->String{
        let formatter = DateFormatter()
        
        // define dateFormat "dd MMM" if given date and selecting day is equal, oherewise "dd".
        formatter.dateFormat = (isSameMonth(date: currentDay, date2: date) ? "MMM yyyy" : "MMM")
        // return "Today," + defined Format before if given date is today and given date and selecting date is equal, otherwise the date as "dd" format
        return (isDateThisMonth(date: date) && isSameMonth(date: currentDay, date2: date) ? "" : "") +  formatter.string(from: date)
    }
    
    /*
     return true if given date is today, Otherewise false.
     */
    func isDateThisMonth(date: Date)->Bool{
        let calender = Calendar(identifier: .gregorian)
        let thisMonth = Date()
        return calender.isDate(date, equalTo: thisMonth, toGranularity: .month)
    }

    /*
     return true if given date1 and date2 is equal, Otherewise false.
     */
    func isSameMonth(date: Date, date2:Date)->Bool{
        let calender = Calendar(identifier: .gregorian)
        return calender.isDate(date, equalTo: date2, toGranularity: .month)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
