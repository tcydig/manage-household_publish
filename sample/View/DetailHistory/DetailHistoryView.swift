//
//  DetailHistoryView.swift
//  dashBordForExpence
//
//  Created by 土屋大胡 on 2023/05/18.
//

import SwiftUI

struct DetailHistoryView: View {
    
    // viewModel class
    @ObservedObject var viewModel = DetailHistoryViewModel()
    // valialbe from previouse page
    var expenseId:Int
    var toCategory:String
    var yearMonth:Date

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                Text("Detail History")
                    .font(.title)
                    .fontWeight(.bold)
                
                if viewModel.isLoading {
                    ActivityIndicator()
                } else {
                    ForEach(viewModel.historyActivity) { list in
                        if list.category == "u" {
                            HStack {
                                VStack{
                                        
                                        Text(list.expenseName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                        Spacer()
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
                                    
                                        Spacer()
                                        
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
            viewModel.fetchHistoryActivity(expenseId: expenseId,toCategory: toCategory,yearMonth: yearMonth)
        }
    }
}

struct DetailHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        DetailHistoryView(expenseId:1,toCategory:"h",yearMonth:Date())
    }
}
