import Foundation

class WalletCoinViewModel: ObservableObject {
    
    @Published var coin: Coin? = nil
    @Published var coinSymbol: String
    @Published var holdings: Double
    
    init(coin: Coin?, symbol: String, holding: Double){
        self.coin = coin
        self.coinSymbol = symbol
        self.holdings = holding
    }
    
}
