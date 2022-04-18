//
//  CoinDetail.swift
//  FYP
//
//  Created by Nursultan Zakirov on 12/4/2022.
//

import Foundation

//https://api.coingecko.com/api/v3/coins/ethereum?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false

struct CoinDetail : Codable{

    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: WelcomeLinks?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
    var readableDescription: String? {
        return description?.en?.removedHTMLCode
    }
}

// MARK: - WelcomeLinks
struct WelcomeLinks : Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

// MARK: - Description
struct Description : Codable{
    let en: String?
}
