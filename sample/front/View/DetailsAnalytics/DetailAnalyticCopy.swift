//
//  DetailsAnalytics.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/14.
//

import SwiftUI
import Charts

struct DetailsAnalyticCopy: View {
    @State var sampleAnalytics: [Expense] = sample_analytics
    
    @State var currentTab: String = "7 Days"
    
    @State var currentActiveItem: Expense?
    @State var plotWidth: CGFloat = 0
    
    @State var isLineGraph: Bool = true
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                Text("Personal")
                    .font(.title)
                    .fontWeight(.bold)
                ZStack {
                    VStack(spacing: 10){
                        Text("Total Balance")
                            .fontWeight(.bold)
                        Text("$ 51 200")
                            .font(.system(size: 38, weight: .bold))
                        Text("↑ 1000")
                            .foregroundColor(.green)
                            + Text(" than last mont")
                        
                    }
                    .padding(.top,-180)
                    AnimatedChart()
                }
            }
            
        }
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
        
//        NavigationStack{
//            VStack{
//                VStack(alignment: .leading, spacing: 12){
//                    HStack{
//                        Text("Views")
//                            .fontWeight(.semibold)
//
//                        Picker("", selection: $currentTab) {
//                            Text("7 Days")
//                                .tag("7 Days")
//                            Text("Week")
//                                .tag("Week")
//                            Text("Month")
//                                .tag("Month")
//                        }
//                        .pickerStyle(.segmented)
//                        .padding(.leading, 80)
//
//
//                    }
//
//                    let totalValue = sampleAnalytics.reduce(0.0) { partialResult, item in
//                        item.views +  partialResult
//                    }
//
//                    Text(totalValue.stringFormat)
//                        .font(.largeTitle.bold())
//
//                    AnimatedChart()
//                }
//                .padding()
//                .background{
//                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                        .fill(.white.shadow(.drop(radius: 2)))
//                }
//                Toggle("Line Graph", isOn: $isLineGraph)
//                    .padding(.top)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//            .padding()
//            .navigationTitle("Swift Charts")
//            .onChange(of: currentTab) { newValue in
//                sampleAnalytics = sample_analytics
//                if newValue != "7 Days"{
//                    for (index,_) in sampleAnalytics.enumerated(){
//                        sampleAnalytics[index].views = .random(in: 1500...10000)
//                        print(sampleAnalytics[index])
//                    }
//                }
//                animateGraph(fromChange: true)
//            }
//
//        }
        
        
    }
    
    @ViewBuilder
    func AnimatedChart()->some View{
        let max = sampleAnalytics.max{item1, item2 in
            return item2.views > item1.views
        }?.views ?? 0
        
        Chart{
            ForEach(sampleAnalytics){item in
                
                if isLineGraph{
                    LineMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(.blue.gradient)
                    .interpolationMethod(.linear)
                    
                }else{
                    BarMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                
                if isLineGraph{
                    AreaMark(
                        x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(.blue.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
                
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Hour", currentActiveItem.hour))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2],dashPhase: 5))
                        .offset(x: (plotWidth / CGFloat(sampleAnalytics.count)) / 2)
                        .annotation(position: .top){
                            VStack(alignment: .leading, spacing: 6){
                                Text("View")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text(currentActiveItem.views.stringFormat2)
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
            }
        }
        .chartYAxis(.hidden)
        
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
                                    let hour = calendar.component(.hour, from: date)
                                    if let currentItem = sampleAnalytics.first(where: {item in
                                        calendar.component(.hour, from: item.hour) == hour
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }.onEnded{value in
                                self.currentActiveItem = nil
                            }
                    )
            }
        })
        .frame(height: 400)
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false){
        for (index,_) in sampleAnalytics.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)){
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)){
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
}

struct DetailsAnalyticCopyView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsAnalyticsHomeView()
    }
}

extension Double {
    var stringFormat2: String{
        if self >= 10000 && self < 999999{
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999{
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
    }
}
