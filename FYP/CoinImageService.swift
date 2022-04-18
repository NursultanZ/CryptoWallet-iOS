//
//  CoinImageService.swift
//  FYP
//
//  Created by Nursultan Zakirov on 4/4/2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var sub: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    
    init(coin: Coin){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: self.coin.id, folderName: self.folderName){
            self.image = savedImage
        }else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        guard let newURL = URL(string: coin.image) else {
            return
        }
        
        sub = NetworkService.download(url: newURL)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkService.handleCompletion, receiveValue: {[weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = downloadedImage
                self.sub?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.coin.id, folderName: self.folderName)
            })
    }
}
