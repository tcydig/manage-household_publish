//
//  DetailsAnalytics.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/14.
//

import SwiftUI
import Charts

struct DetailsAnalyticsHomeView: View {
    
    // viewModel class
    @ObservedObject var viewModel = DetailsAnalyticsViewModel()
    // valiable to show line graph
    @State var currentActiveItem: ExpenseViewEntity?
    // list for horizontal scrolling menu of months
    @State var months: [String] = []
    // selectin month
    @State var currentMonth: String = ""
    @State var plotWidth: CGFloat = 0
    // argument from previous page
    var expenseId:Int
    var expenseName:String
    var pageCategory:String
    var userId:Int
    
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                Color(.green).opacity(0.3),
                Color(.green).opacity(0.1),
                Color(.green).opacity(0.0)
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                Text(expenseName)
                    .font(.title)
                    .fontWeight(.bold)
                if viewModel.isLoading {
                    ActivityIndicator()
                } else {
                    ZStack {
                        VStack(spacing: 10){
                            Text("Total Balance")
                                .fontWeight(.bold)
                            Text("¥ \(viewModel.totalBalance)")
                                .font(.system(size: 38, weight: .bold))
                            if viewModel.totalBalanceDifference < 0 {
                                Text("↓ \(viewModel.totalBalanceDifference)")
                                    .foregroundColor(.green)
                                    + Text(" than last mont")
                            } else if viewModel.totalBalanceDifference > 0 {
                                Text("↑ \(viewModel.totalBalanceDifference)")
                                    .foregroundColor(.red)
                                    + Text(" than last mont")
                            } else {
                                Text("↑↓ \(viewModel.totalBalanceDifference)")
                                    .foregroundColor(.orange)
                                    + Text(" than last mont")
                            }
                            AnimatedChart()
                                .padding(.top,-100)
                            
                            ScrollView([.horizontal]) {
                                HStack(spacing: 20){
                                    ForEach(months, id: \.self) {date in
                                        Text(date)
                                            .foregroundColor(date == currentMonth ? .white : .gray)
                                            .fontWeight(date == currentMonth ? .bold : .semibold)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, date == currentMonth ? 1 : 0)
                                            .padding(.horizontal, date == currentMonth ? 2 : 0)
                                            .frame(width: date == currentMonth ? 50 : nil)
                                            .background(
                                                Capsule()
                                                    .fill(.ultraThinMaterial)
                                                    .environment(\.colorScheme, .light)
                                                    .opacity(date == currentMonth ? 0.8 : 0)
                                            )
                                    }
                                }
                            }
                            HStack {
                                Text("Recent History")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if viewModel.historyList.isEmpty {
                                Text("History is nothing in this month")
                                    .padding(.top, 10)
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(viewModel.historyList) { list in
                                    
                                    if list.category == "u" {
                                        HStack {
                                            VStack{
                                                Text(list.expenseName)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text("From: \(list.userName)")
                                                    .fontWeight(.medium)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .foregroundColor(.gray)
                                                
                                                Text("To: \(list.toUserName)")
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
                                    } else {
                                        HStack {
                                            VStack{
                                                Text(list.expenseName)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text("From: \(list.userName)")
                                                    .fontWeight(.medium)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .foregroundColor(.gray)
                                                
                                                Text("To: Home")
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
                        }
                    }
                    .padding(.top, 20)
                }

            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
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
            getMonthsForSevenMonth()
            viewModel.fetchExpenseView(expenseId: expenseId,pageCategory: pageCategory,userId: userId,yearMonth: Date())
        }
        
    }
    
    @ViewBuilder
    func AnimatedChart()->some View{
        let max = viewModel.expenseView.max{item1, item2 in
            return item2.totalBalance > item1.totalBalance
        }?.totalBalance ?? 0
        
        Chart{
            ForEach(viewModel.expenseView){item in
                LineMark(

                    x: .value("Month", item.yearMonth, unit: .month),
                    y: .value("Expenses", item.totalBalance)
                )
                .foregroundStyle(.green.gradient)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Month", item.yearMonth, unit: .month),
                    y: .value("Expenses", item.totalBalance)
                )
                .foregroundStyle(curGradient)
                .interpolationMethod(.catmullRom)
                

                if let currentActiveItem, currentActiveItem.id == item.id {
                    
                    PointMark(
                        x: .value("Month", item.yearMonth, unit: .month),
                        y: .value("Expenses", item.totalBalance)
                    )
                    .foregroundStyle(.green.gradient)
                    .annotation(position: .top){
                        HStack(spacing: 6) {

                            
                            if viewModel.totalBalanceDifference < 0 {
                                Image(systemName: "arrow.down")
                                    .foregroundColor(.green)
                                Text("\(viewModel.totalBalanceDifference)")
                                    .foregroundColor(.green)
                            } else if viewModel.totalBalanceDifference > 0 {
                                Image(systemName: "arrow.up")
                                    .foregroundColor(.red)
                                Text("\(viewModel.totalBalanceDifference)")
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "arrow.up")
                                    .foregroundColor(.orange)
                                    .padding(.trailing, -10)
                                Image(systemName: "arrow.down")
                                    .foregroundColor(.orange)
                                Text("\(viewModel.totalBalanceDifference)")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.gray.shadow(.drop(radius: 2)))
                        }
                    }
                }
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartYScale(domain: 0...(max + 5000))
        .chartOverlay(content: { proxy in
            GeometryReader{innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x){
                                    let calendar = Calendar.current
                                    let month = calendar.component(.month, from: date)
                                    if let currentItem = viewModel.expenseView.first(where: {item in
                                        calendar.component(.month, from: item.yearMonth) == month
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                        
                                        viewModel.updateTotalBalance(index: currentItem.id)
                                        viewModel.updateBeforeDifferenceBalance(index: currentItem.id)
                                        
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.calendar = Calendar(identifier: .gregorian)
                                        dateFormatter.dateFormat = "MMM"
                                        
                                        self.currentMonth = dateFormatter.string(from: currentItem.yearMonth)
                                    }
                                }
                            }.onEnded{value in
                                self.currentActiveItem = nil
                            }
                    )
            }
        })
        .frame(height: 300)
        .padding(.top, 40)
        .onAppear {
            animateGraph()
        }
        

    }
    
    func animateGraph(fromChange: Bool = false){
        for (index,_) in viewModel.expenseView.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)){
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)){
                    viewModel.expenseView[index].animate = true
                }
            }
        }
    }
    
    func getMonthsForSevenMonth() {
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMM"
        months.removeAll()
        for i in -6..<1 {
            let sampleMonth = Calendar.current.date(byAdding: .month, value: i, to: today)!
            months.append(dateFormatter.string(from: sampleMonth))
        }
        
        self.currentMonth = self.months[6]
    }
}

struct DetailsAnalyticsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsAnalyticsHomeView(expenseId: 1,expenseName:"Rent",pageCategory: "h",userId: 1)
    }
}

extension Double {
    var stringFormat: String{
        if self >= 10000 && self < 999999{
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999{
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
    }
}
