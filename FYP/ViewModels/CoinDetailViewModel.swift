//
//  CoinDetailViewModel.swift
//  FYP
//
//  Created by Nursultan Zakirov on 12/4/2022.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject{
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailDS: CoinDetailDataService
    
    @Published var coin: Coin
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin){
        self.coin = coin
        self.coinDetailDS = CoinDetailDataService(coin: coin)
        self.addSubs()
    }
    
    
    private func addSubs(){
        coinDetailDS.$details
            .combineLatest($coin)
            .map({ (coinDetail, coin) -> (overview: [Statistic], additional: [Statistic]) in
                
                var overviewArray: [Statistic] = []
                var additionalArray: [Statistic] = []
                
                
                //overview
                let price = coin.currentPrice.currencyFormat6()
                let pricePercentChange = coin.priceChangePercentage24H
                let priceStat = Statistic(title: "Price", value: price, percentChange: pricePercentChange)
                
                let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
                let marketCapPercentChange = coin.marketCapChangePercentage24H
                let marketCapStat = Statistic(title: "Market Cap", value: marketCap, percentChange: marketCapPercentChange)
                
                let rank = "\(coin.rank)"
                let rankStat = Statistic(title: "Rank", value: rank)
                
                let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = Statistic(title: "Daily Volume", value: volume)
                
                overviewArray = [
                    priceStat,
                    marketCapStat,
                    rankStat,
                    volumeStat
                ]
                
                //additional
                
                let high = coin.high24H?.currencyFormat6() ?? "N/A"
                let highStat = Statistic(title: "24h High", value: high)
                
                let low = coin.low24H?.currencyFormat6() ?? "N/A"
                let lowStat = Statistic(title: "24h Low", value: low)
                
                let priceChange = coin.priceChange24H?.currencyFormat6() ?? "N/A"
                let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentChange: pricePercentChange)
                
                let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentChange: marketCapPercentChange)
                
                let blockTime = coinDetail?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "N/A": "\(blockTime)"
                let blockStat = Statistic(title: "Block Time", value: blockTimeString)
                
                let hashing = coinDetail?.hashingAlgorithm ?? "N/A"
                let hashStat = Statistic(title: "Hashing Algorithm", value: hashing)
                
                additionalArray = [
                    highStat,
                    lowStat,
                    priceChangeStat,
                    marketCapChangeStat,
                    blockStat,
                    hashStat
                ]
                
                return (overviewArray, additionalArray)
            })
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailDS.$details
            .sink { [weak self] returnedDetails in
                self?.coinDescription = returnedDetails?.readableDescription
                self?.websiteURL = returnedDetails?.links?.homepage?.first
                self?.redditURL = returnedDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
}
