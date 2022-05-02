//
//  AppView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 19/4/2022.
//

import SwiftUI

struct AppView: View {
    
    @StateObject private var marketVM = MarketViewModel()
    
    @EnvironmentObject private var appVM: AppViewModel
    
    var body: some View {
        VStack{
            TabView{
                MarketView()
                    .tabItem{
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Markets")
                    }
                    .environmentObject(marketVM)
                WalletView()
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

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(dev.appVM)
            .preferredColorScheme(.light)
    }
}

//func authenticate() {
//    let context = LAContext()
//        var error: NSError?
//
//        // check whether biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            // it's possible, so go ahead and use it
//            let reason = "To unlock your wallet data."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                if success {
//                    isUnlocked = true
//                } else {
//                    // there was a problem
//                }
//            }
//        } else {
//            // no biometrics
//        }
//}
