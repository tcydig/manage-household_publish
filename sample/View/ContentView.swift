//
//  ContentView.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/09.
//

import SwiftUI

struct ContentView: View {
    
    @State var showView: Bool = false
    
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    if showView{
                        Home()
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
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showView = true
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
            }
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    if showView{
                        Personal()
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
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showView = true
                    }
                }
            }
            .tabItem{
                Image(systemName: "person.fill")
            }
            NavigationStack {
                EditExpensesView()
            }
            .tabItem{
                Image(systemName: "book.closed.fill")
            }
            NavigationStack {
                EditUserExpensesView()
            }
            .tabItem{
                Image(systemName: "pencil")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Plus"))
    }
}
