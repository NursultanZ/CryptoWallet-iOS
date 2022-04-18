//
//  MarketViewModel.swift
//  FYP
//
//  Created by Nursultan Zakirov on 28/3/2022.
//

import Foundation
import Combine
import SwiftUI

class MarketViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var walletCoins: [Coin] = []
    
    @Published var searchText: String = ""
    
    @Published var listOrder: ListOrder = .topCap
    
    @Published var statistics: [Statistic] = []
    
    @Published var showCoins: Bool = false
    
    private let coinDS = CoinDataService()
    private let marketDS = MarketDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum ListOrder: String {
        case topCap = "Highest Cap"
        case lowCap = "Lowest Cap"
        case topVol = "Highest Volume"
        case lowVol = "Lowest Volume"
        case gainers = "Top Gainers"
        case losers = "Top Losers"
    }

    
    init(){
        addSubs()
    }
    
    func changeOrder(_ order: ListOrder){
        listOrder = order
    }
    
    func getOrderedCoins(_ order: ListOrder?) -> [Coin]{
        var newOrder: ListOrder
        
        if order == nil{
            newOrder = self.listOrder
        }else {
            newOrder = order!
        }
        
        return self.allCoins.sorted(by: {
            switch newOrder {
            case .topCap:
                return $0.marketCap ?? 0.0 > $1.marketCap ?? 0.0
            case .lowCap:
                return $0.marketCap ?? 0.0 < $1.marketCap ?? 0.0
            case .topVol:
                return $0.totalVolume ?? 0.0 > $1.totalVolume ?? 0.0
            case .lowVol:
                return $0.totalVolume ?? 0.0 > $1.totalVolume ?? 0.0
            case .gainers:
                return $0.priceChangePercentage24H ?? 0.0 > $1.priceChangePercentage24H ?? 0.0
            case .losers:
                return $0.priceChangePercentage24H ?? 0.0 < $1.priceChangePercentage24H ?? 0.0
            }
        })
    }
    
    func reloadData() {
        coinDS.getCoins()
        marketDS.getData()
    }
    
    func addSubs(){
        
        $searchText
            .combineLatest(coinDS.$allCoins)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .map { (text, coins) -> [Coin] in
                
                guard !text.isEmpty else {
                    return coins
                }
                
                let lowercasedText = text.lowercased()
                
                return coins.filter { coin -> Bool in
                    return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        marketDS.$marketData
            .map({ (marketData) -> [Statistic] in
                var stats: [Statistic] = []
                
                guard let data = marketData else {
                    return stats
                }
                
                let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentChange: data.marketCapChangePercentage24HUsd)
                
                let volume = Statistic(title: "Trading Volume", value: data.volume)
                
                let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                
                stats.append(contentsOf: [marketCap, volume, btcDominance])
                
                return stats
            })
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
    }
    
}
