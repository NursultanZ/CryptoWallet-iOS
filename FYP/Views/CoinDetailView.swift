import SwiftUI

struct CoinDetailLoadingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var coin: Coin?
    
    init(coin: Binding<Coin?>){
        self._coin = coin
    }
    
    var body: some View {
        NavigationView {
            if let coin = self.coin {
                ZStack {
                    Color.custom.secondaryBackground.ignoresSafeArea(.all)
                    CoinDetailView(coin: coin)
                        .toolbar {
                            ToolbarItem (placement: .navigationBarLeading){
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.custom.yellow)
                                    .onTapGesture {
                                        dismiss()
                                    }
                            }
                    }
                }
            }
        }
    }
}

struct CoinDetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    @State var showFullDesc: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    var coin: Coin
    
    init(coin: Coin){
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack (){
                ChartView(coin: coin)
                    .padding(.vertical)
                
                
                VStack{
                    overviewTitle
                    Divider()
                    
                    ZStack {
                        if let desc = vm.coinDescription, !desc.isEmpty {
                            VStack(alignment: .leading) {
                                Text(desc)
                                    .lineLimit(showFullDesc ? nil : 3)
                                    .font(.callout)
                                    .foregroundColor(Color.custom.secondaryText)
                                
                                Button {
                                    withAnimation(.easeInOut) {
                                        showFullDesc.toggle()
                                    }
                                } label: {
                                    Text(showFullDesc ? "Read Less" : "Read More...")
                                        .font(.subheadline)
                                        .bold()
                                        .padding(.vertical, 3)
                                        .foregroundColor(Color.custom.yellow)
                                }

                            }
                        }
                    }
                    
                    LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
                        ForEach(vm.overviewStatistics){ stat in
                            StatisticView(stat: stat)
                        }
                    }
                    
                    additionalTitle
                    Divider()
                    
                    LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
                        ForEach(vm.additionalStatistics){ stat in
                            StatisticView(stat: stat)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        if let websiteString = vm.websiteURL, let websiteURL = URL(string: websiteString) {
                            Link("Website", destination: websiteURL)
                        }
                        
                        if let redditString = vm.redditURL, let redditURL = URL(string: redditString) {
                            Link("Reddit", destination: redditURL)
                        }
                    }
                    .accentColor(Color.custom.yellow)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                }
                .padding()
                
            }
        }
        .navigationTitle(coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                HStack {
                    Text(coin.symbol.uppercased())
                        .font(.headline)
                    .foregroundColor(Color.custom.secondaryText)
                    CoinImageView(coin: coin)
                        .frame(width: 35, height: 35, alignment: .trailing)
                    
                }
            }
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailLoadingView(coin: .constant(dev.coin))
            .preferredColorScheme(.light)
    }
}


extension CoinDetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.custom.mainText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.custom.mainText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
