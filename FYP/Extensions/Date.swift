//
//  Date.swift
//  FYP
//
//  Created by Nursultan Zakirov on 13/4/2022.
//

import Foundation

extension Date {
    
    //2021-03-13T23:18:10.268Z
    init(coinGeckoDate: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoDate) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
