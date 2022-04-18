//
//  CoinsView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 9/4/2022.
//

import SwiftUI

struct CoinsView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var marketVM: MarketViewModel
    
    @State private var showDetails: Bool = false
    @State private var selectedCoin: Coin? = nil
    
    var body: some View {
            VStack{
                NavigationView{
                    VStack {
                        List {
                            Section(){
                                ForEach(marketVM.getOrderedCoins(nil)){ coin in
                                    CoinRowView(coin: coin, showHoldings: false)
                                        .onTapGesture {
                                            showDetails = true
                                            selectedCoin = coin
                                        }
                                }
                                    
                            }
                        }
                        .listStyle(.plain)
                        .searchable(text: $marketVM.searchText, placement: .automatic, prompt: "Search")
                        .toolbar {
                            ToolbarItem (placement: .destructiveAction){
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.custom.yellow)
                                    .onTapGesture {
                                        dismiss()
                                    }
                            }
                        }
                    }
                    .navigationTitle("All Coins")
                }
                .sheet(isPresented: $showDetails) {
                    CoinDetailLoadingView(coin: $selectedCoin)
                }
            }
        
    }
}

struct CoinsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsView()
            .preferredColorScheme(.dark)
            .environmentObject(dev.marketVM)
    }
}
