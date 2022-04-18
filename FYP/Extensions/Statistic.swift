//
//  Statistic.swift
//  FYP
//
//  Created by Nursultan Zakirov on 6/4/2022.
//

import Foundation

struct Statistic: Identifiable {
    
    let id = UUID().uuidString
    
    let title: String
    let value: String
    let percentChange: Double?
    
    init(title: String, value: String, percentChange: Double? = nil){
        self.title = title
        self.value = value
        self.percentChange = percentChange
    }
}
