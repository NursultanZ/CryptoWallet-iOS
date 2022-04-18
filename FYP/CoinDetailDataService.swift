//
//  CoinDetailDataService.swift
//  FYP
//
//  Created by Nursultan Zakirov on 12/4/2022.
//

import Foundation
import Combine


class CoinDetailDataService {
    
    @Published var details: CoinDetail? = nil
    
    var coinDetailSub: AnyCancellable?
    
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getDetail()
    }
    
    func getDetail(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(self.coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            return
        }
        
        coinDetailSub = NetworkService.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: {[weak self] returnedDetails in
                self?.details = returnedDetails
                self?.coinDetailSub?.cancel()
            })
    }
    
}
