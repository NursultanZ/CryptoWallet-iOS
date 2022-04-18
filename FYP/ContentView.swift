//
//  ContentView.swift
//  FYP
//
//  Created by user on 26/1/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var marketVM = MarketViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.custom.secondaryBackground)
    }
    
    var body: some View {
        ZStack{
            Color.custom.secondaryBackground.edgesIgnoringSafeArea(.all)
            if (marketVM.allCoins.isEmpty || marketVM.statistics.isEmpty){
                
            }else {
                VStack{
                    TabView{
                        MarketView()
                            .tabItem{
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                Text("Markets")
                            }
                            .environmentObject(marketVM)
                        Button("Generate", action: display)
                            .tabItem{
                                Image(systemName: "externaldrive.fill")
                                Text("Wallet")
                            }
                        Text("History")
                            .tabItem{
                                Image(systemName: "list.dash")
                                Text("Transactions")
                            }
                        Text("Settings")
                            .tabItem{
                                Image(systemName: "gearshape")
                                Text("Settings")
                            }
                    }
                    .accentColor(Color.custom.yellow)
                }
            }
        }
    }
    
    func display(){
        do {
            let pk = HDPrivateKey(seed: Data(hex: "000102030405060708090a0b0c0d0e0f"), xPrv: 0x0488ade4, xPub: 0x0488b21e)
            let keychain = HDKeychain(privateKey: pk)
            print(keychain.deriveKey(path: "0'/1/2'").getPublicKey().serialized())
        }catch{
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
