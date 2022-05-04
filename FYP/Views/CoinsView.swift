import SwiftUI

struct CoinsView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var marketVM: MarketViewModel
    
    @State private var showDetails: Bool = false
    @State private var selectedCoin: Coin? = nil
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                VStack {
                    List {
                        Section(){
                            ForEach(marketVM.getOrderedCoins(nil)){ coin in
                                CoinRowView(coin: coin, showHoldings: false, backgroundColor: Color.custom.secondaryBackground)
                                    .onTapGesture {
                                        showDetails = true
                                        selectedCoin = coin
                                    }
                            }
                            .listRowBackground(Color.custom.secondaryBackground)
                                
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
        }
        .sheet(isPresented: $showDetails) {
            CoinDetailLoadingView(coin: $selectedCoin)
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
