import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketData? = nil
    
    var sub: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }
        
        sub = NetworkService.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: {[weak self] data in
                self?.marketData = data.data
                self?.sub?.cancel()
            })
    }
    
}

