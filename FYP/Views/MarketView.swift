import SwiftUI

struct MarketView: View {
    
    @EnvironmentObject private var marketVM: MarketViewModel
    
    @State private var showDetails: Bool = false
    @State private var selectedCoin: Coin? = nil
    
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color.custom.secondaryBackground)
        UITableView.appearance().isScrollEnabled = false
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.custom.secondaryBackground.ignoresSafeArea()
                VStack{
                    if(marketVM.allCoins.count == 0 || marketVM.statistics.count == 0){
                        ProgressView()
                    }else{
                        HorizontalStatistics()
                            .environmentObject(marketVM)
                        
                        List{
                            
                            GroupedCoins(selectedCoin: $selectedCoin, showDetails: $showDetails, text: "All Coins", order: .topCap)
                            GroupedCoins(selectedCoin: $selectedCoin, showDetails: $showDetails, text: "Top Gainers", order: .gainers)
                            GroupedCoins(selectedCoin: $selectedCoin, showDetails: $showDetails, text: "Top Losers", order: .losers)
                        }
                        .refreshable {
                            marketVM.reloadData()
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .navigationTitle("Markets")
            }
            .sheet(isPresented: $marketVM.showCoins) {
                CoinsView()
                    .environmentObject(marketVM)
            }
            .sheet(isPresented: $showDetails) {
                CoinDetailLoadingView(coin: $selectedCoin)
            }
        }
    }
    
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
            .environmentObject(dev.marketVM)
            .preferredColorScheme(.light)
    }
}


struct SectionFooter: View{
    var body: some View {
        HStack {
            Text("See All")
                .foregroundColor(Color.custom.mainText)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.custom.secondaryText)
        }
        .background(Color.custom.background)
        .listRowBackground(Color.custom.background)
    }
}

struct SectionHeader: View {
    var text: String
    var body: some View {
        HStack{
            Text(text)
                .font(.subheadline)
                .foregroundColor(Color.custom.mainText)
        }
    }
}

struct HorizontalStatistics: View {
    @EnvironmentObject private var marketVM: MarketViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(marketVM.statistics){ statistic in
                    StatisticView(stat: statistic)
                        .frame(width: UIScreen.main.bounds.size.width / 3)
                        .background(
                            RoundedRectangle(cornerRadius: 13)
                                .fill(Color.custom.background)
                        )
                }
            }
        }
        .padding([.leading,.trailing], 20)
    }
}

struct GroupedCoins: View {
    
    @EnvironmentObject private var marketVM: MarketViewModel
    
    @Binding var selectedCoin: Coin?
    @Binding var showDetails: Bool
    
    var text: String
    var order: MarketViewModel.ListOrder
    
    var body: some View {
            
        Section (header: SectionHeader(text: text)){
            ForEach(marketVM.getOrderedCoins(order).prefix(5)) { coin in
                CoinRowView(coin: coin, showHoldings: false, backgroundColor: Color.custom.background)
                    .onTapGesture {
                        selectedCoin = coin
                        showDetails = true
                    }
            }
            .listRowBackground(Color.custom.background)
            
            SectionFooter().onTapGesture {
                marketVM.changeOrder(order)
                marketVM.showCoins = true
            }
        }

    }
}
