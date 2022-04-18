//
//  CoinDataService.swift
//  FYP
//
//  Created by Nursultan Zakirov on 29/3/2022.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [Coin] = []
    
    var sub: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        sub = NetworkService.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: {[weak self] coins in
                self?.allCoins = coins
                self?.sub?.cancel()
            })
    }
    
}
