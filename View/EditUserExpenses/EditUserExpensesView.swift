//
//  EditUserExpenses.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/06/12.
//

import SwiftUI
import Algorithms

struct EditUserExpensesView: View {
    
    // viewModel class
    @ObservedObject var viewModel = EditUserExpensesViewModel()
    // pullDown of Category (default is Rent)
    private let categoryList:[String] = ["Rent","Gas","Water","Electric","Internet","Food","Others"]
    // selecting category
    @State private var selectedCategory = "Rent"
    // index of selecting category
    @State private var selectedCategoryId = 1
    // current status
    @State var currentStatus: String = "A"
    @State var currentToUserId: Int = 2
    // modal status
    @State private var showingModal = false
    @State var months: [Date] = []
    // current selected picker
    @State var pickerIndex: Int = 0
    // header viewModel class
    @ObservedObject private var headerViewModel = HeaderViewModel.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                
                // Header
                HStack{
                    Text("Expenses Of Personal")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()

                    Picker("", selection: $headerViewModel.userId) {
                        Text("Kurisu").tag(2)
                        Text("Tawara").tag(1)
                    }
                    .onChange(of: headerViewModel.userId){ newValue in
                        headerViewModel.Change(selectedUserId: newValue)
                        viewModel.fetchEditExpenses(userId: newValue)
                    }
                }
                .foregroundColor(.white)
                .padding(15)
                
                // Scrolling menu for months
                ScrollView([.horizontal]){
                    // scrolling date header
                    HStack(spacing: 10){
                        ForEach(months, id: \.self) {date in
                            Text(extractYearMonth(date:date))
                                .fontWeight(isSameMonth(date: viewModel.currentDay, date2: date) ? .bold: .semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical,isSameMonth(date: viewModel.currentDay, date2: date) ? 6: 0)
                                .padding(.horizontal,isSameMonth(date: viewModel.currentDay, date2: date) ? 12: 0)
                                .frame(width: isSameMonth(date: viewModel.currentDay, date2: date) ? 140 : nil)
                                .background(
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                        .opacity(isSameMonth(date: viewModel.currentDay, date2: date) ? 0.8 : 0)
                                )
                                .onTapGesture {
                                    withAnimation{
                                        viewModel.currentDay = date
                                        viewModel.extractCurrentExpenses(selectingMonth: viewModel.currentDay)
                                    }
                                }
                        }
                    }
                }
                
                if viewModel.isEditable {
                    Text("Editable")
                        .foregroundColor(.green)
                        .font(.title)
                        .frame(width: 130, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1)
                        )
                        .shadow(color: Color.green, radius: 20, x: 0, y: 0)
                        .shadow(color: Color.green.opacity(0.7), radius: 1, x: 0, y: 0)
                        .compositingGroup()
                        .shadow(color: .green, radius: 3, x: 2, y: 3)
                } else {
                    Text("Uneditable")
                        .foregroundColor(.red)
                        .font(.title)
                        .frame(width: 160, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1)
                        )
                        .shadow(color: Color.red, radius: 20, x: 0, y: 0)
                        .shadow(color: Color.red.opacity(0.7), radius: 1, x: 0, y: 0)
                        .compositingGroup()
                        .shadow(color: .red, radius: 3, x: 2, y: 3)
                }
                
                // input expense
                VStack(spacing: 10){
                    if (headerViewModel.userId == currentToUserId) {
                        let  totalbalance = currentStatus == "A" ? viewModel.yourBalance + viewModel.inputExpense : viewModel.yourBalance - viewModel.inputExpense
                        Text("\(totalbalance) Yen")
                            .font(.title3)
                            .foregroundColor(.gray)
                    } else {
                        let  totalbalance = currentStatus == "A" ? viewModel.otherBalance + viewModel.inputExpense : viewModel.otherBalance - viewModel.inputExpense
                        Text("\(totalbalance) Yen")
                            .font(.title3)
                            .foregroundColor(.gray)
                        }
                    HStack{
                        Text("¥")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(.bottom,10)
                            .padding(.trailing, -5)
                        Text("\(viewModel.inputExpense)")
                            .font(.system(size: 45, weight: .bold))
                    }

                }
                
                // chose user
                Grid{
                    GridRow{
                        Button(action: {
                            currentToUserId = 1
                        }, label:{
                            if (currentToUserId == 2) {
                                Text("Tawara")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            } else {
                                Text("Tawara")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                    .foregroundColor(currentStatus == "A" ? .red : .white)
                                    .shadow(color: Color.orange, radius: 15, x: 0, y: 0)
                                    .shadow(color: Color.orange.opacity(0.7), radius: 1, x: 0, y: 0)
                            }

                        })
                        
                        Button(action: {
                            currentToUserId = 2
                        }, label:{
                            if (currentToUserId == 2) {
                                Text("Mayummi")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                    .shadow(color: Color.orange, radius: 15, x: 0, y: 0)
                                    .shadow(color: Color.orange.opacity(0.7), radius: 1, x: 0, y: 0)
                            } else {
                                Text("Mayummi")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }

                        })
                        
                    }
                    Divider()
                }
                
                // pulldown for categories
                Grid{
                    GridRow{
                        Menu {
                            ForEach(Array(categoryList.enumerated()), id: \.offset) { offset, item in
                                Button {
                                    selectedCategoryId = offset + 1
                                    print(selectedCategoryId)
                                    selectedCategory = categoryList[offset]
                                    viewModel.extractTotalBalance(index:offset)
                                } label: {
                                    Text("\(categoryList[offset])")
                                        .font(.title2)
                                }
                            }
                        } label: {
                            Text("\(selectedCategory)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    Divider()
                }
                
                // status for delete or add
                Grid{
                    GridRow{
                        Button(action: {
                            currentStatus = "D"
                        }, label:{
                            if (currentStatus == "A") {
                                Text("D")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            } else {
                                Text("D")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .foregroundColor(currentStatus == "A" ? .red : .white)
                                    .shadow(color: Color.red, radius: 15, x: 0, y: 0)
                                    .shadow(color: Color.red.opacity(0.7), radius: 1, x: 0, y: 0)
                                    .shadow(color: .red, radius: 3, x: 2, y: 3)
                            }

                        })
                        
                        Button(action: {
                            currentStatus = "A"
                        }, label:{
                            if (currentStatus == "A") {
                                Text("A")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .shadow(color: Color.green, radius: 15, x: 0, y: 0)
                                    .shadow(color: Color.green.opacity(0.7), radius: 1, x: 0, y: 0)
                                    .shadow(color: .green, radius: 3, x: 2, y: 3)
                            } else {
                                Text("A")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }

                        })
                        
                    }
                    Divider()
                }
                
                // numberBord
                Grid{
                    GridRow{
                        Button(action: {
                            if (viewModel.inputExpense != 0){
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "0")!
                            }
                        }, label:{
                            Text("0")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                        })
                        .buttonStyle(AnimationButtonStyle())
                        
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 1
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "1")!
                            }
                        }, label:{
                            Text("1")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 2
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "2")!
                            }
                        }, label:{
                            Text("2")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                    }
                    Divider()
                    GridRow{
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 3
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "3")!
                            }
                        }, label:{
                            Text("3")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 4
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "4")!
                            }
                        }, label:{
                            Text("4")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 5
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "5")!
                            }
                        }, label:{
                            Text("5")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                    }
                    Divider()
                    GridRow{
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 6
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "6")!
                            }
                        }, label:{
                            Text("6")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 7
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "7")!
                            }
                        }, label:{
                            Text("7")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 8
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "8")!
                            }
                        }, label:{
                            Text("8")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                    }
                    Divider()
                    GridRow{
                        Button(action: {
                            viewModel.inputExpense = 0
                        }, label:{
                            Image(systemName: "arrow.2.squarepath")
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        
                        Button(action: {
                            if (viewModel.inputExpense == 0){
                                viewModel.inputExpense = 9
                            } else {
                                viewModel.inputExpense = Int(String(viewModel.inputExpense) + "9")!
                            }
                        }, label:{
                            Text("9")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                        Button(action: {
                            if (viewModel.inputExpense < 10){
                                viewModel.inputExpense = 0
                            } else {
                                viewModel.inputExpense = Int(String(String(viewModel.inputExpense).dropLast()))!
                            }
                        }, label:{
                            Image(systemName: "delete.left")
                                .foregroundColor(.white)
                        })
                        .buttonStyle(AnimationButtonStyle())
                    }
                    Divider()
                }
                
                // button for sending
                Grid{
                    GridRow{
                        if (viewModel.inputExpense > 0 && viewModel.isEditable && viewModel.inputExpense > 0) {
                            Button(action: {
                                self.showingModal.toggle()
                            }) {
                                Text("SEND")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }.sheet(isPresented: $showingModal){
                                UserModalView(balanceEnterd: viewModel.inputExpense, categoryOfExpenseName: selectedCategory, categoryOfExpenseId: selectedCategoryId, statusOfUpdate: currentStatus, viewModel: viewModel, userId: headerViewModel.userId, toUserId: currentToUserId,yearMonth:viewModel.currentDay)
                            }
                        } else {
                            Text("SEND")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }

                    }
                    
                }
            }
            .onAppear(perform: extractMonths)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading, 15)
        .background{
            ZStack{
                VStack{
                    Circle()
                        .fill(Color(.green))
                        .scaleEffect(0.6)
                        .offset(x: 20)
                        .blur(radius: 120)
                    Circle()
                        .fill(Color(.red))
                        .scaleEffect(0.6, anchor: .leading)
                        .offset(y: -20)
                        .blur(radius: 120)
                }
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.fetchEditExpenses(userId:headerViewModel.userId)
            viewModel.currentDay = Date()
        }
    }
    
    // obtain years and months
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
        formatter.dateFormat = (isSameMonth(date: viewModel.currentDay, date2: date) ? "MMM yyyy" : "MMM")
        
        // return "Today," + defined Format before if given date is today and given date and selecting date is equal, otherwise the date as "dd" format
        return (isDateThisMonth(date: date) && isSameMonth(date: viewModel.currentDay, date2: date) ? "" : "") +  formatter.string(from: date)
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

struct UserAnimationButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Capsule()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
                .opacity(0.8)
                .frame(width: 50, height: 50) : Capsule()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
                .opacity(0)
                .frame(width: 50, height: 50))
    }
}

struct EditUserExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserExpensesView()
    }
}

struct UserModalView: View {
    
    @State private var changeColor = false
    @State private var blur: CGFloat = 5
    
    var balanceEnterd: Int
    var categoryOfExpenseName: String
    var categoryOfExpenseId: Int
    var statusOfUpdate: String
    var viewModel: EditUserExpensesViewModel
    var userId: Int
    var toUserId: Int
    var yearMonth: Date
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20){
                Text("Final confirmation")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Group{
                    VStack{
                        Text("Input Total")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(balanceEnterd)")
                            .font(.system(size: 45, weight: .bold))
                    }
                    Divider()
                    VStack{
                        Text("To User")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if toUserId == 2 {
                            Text("Kurisu")
                                .font(.system(size: 45, weight: .bold))
                        } else {
                            Text("Tawara")
                                .font(.system(size: 45, weight: .bold))
                        }

                    }
                    Divider()
                    VStack{
                        Text("Category Of Expense")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(categoryOfExpenseName)
                            .font(.system(size: 45, weight: .bold))
                    }
                    Divider()
                    VStack{
                        Text("Category Of Updating")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if statusOfUpdate == "A" {
                            Text("ADD")
                                .font(.system(size: 45, weight: .bold))
                        } else {
                            Text("DELET")
                                .font(.system(size: 45, weight: .bold))
                        }

                    }
                    Divider()
                    HStack{
                        Button(action: {
                            viewModel.pushExpense(categoryOfExpense:categoryOfExpenseId,balanceEntered:balanceEnterd,categoryOfUpdate:statusOfUpdate,userId: userId, toUserId: toUserId,yearMonth:yearMonth)
                            dismiss()
                        }) {
                            Text("Uploade")
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .modifier(NeonStyle(color: .blue, blurRadius: $blur))
                        }
                        .frame(maxWidth: .infinity,alignment: .center)
                        .onAppear(perform: animateViews)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading, 15)
        .background{
            ZStack{
                VStack{
                    Circle()
                        .fill(Color(.green))
                        .scaleEffect(0.6)
                        .offset(x: 20)
                        .blur(radius: 120)
                    Circle()
                        .fill(Color(.red))
                        .scaleEffect(0.6, anchor: .leading)
                        .offset(y: -20)
                        .blur(radius: 120)
                }
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
    }
    
    func animateViews(){
        withAnimation(.easeInOut.speed(0.25).repeatForever()) {
            self.blur = 20
        }
    }
}

struct UserNeonStyle: ViewModifier {
    let color: Color
    @Binding var blurRadius: CGFloat
    
    func body(content: Content) -> some View {
        return ZStack {
            content.foregroundColor(color)
            content.blur(radius: blurRadius)
        }
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 12, style:
                .continuous).stroke(color, lineWidth: 2))
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(color, lineWidth: 2).brightness(0.1).blur(radius: blurRadius))
        .background(RoundedRectangle(cornerRadius: 16, style:.continuous).stroke(color, lineWidth: 2).brightness(0.1).blur(radius: blurRadius).opacity(0.2))
        .compositingGroup()
    }
}
