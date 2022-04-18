//
//  CoinImageViewModel.swift
//  FYP
//
//  Created by Nursultan Zakirov on 4/4/2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: Coin
    private let ds: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init (coin: Coin) {
        self.coin = coin
        self.isLoading = true
        self.ds = CoinImageService(coin: coin)
        self.addSubs()
    }
    
    func addSubs() {
        ds.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnImage in
                self?.image = returnImage
            }
            .store(in: &cancellables)

    }
    
}
