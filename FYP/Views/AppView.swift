import SwiftUI

struct AppView: View {
    
    @StateObject private var marketVM = MarketViewModel()
    
    @StateObject private var appVM: AppViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            Color.custom.secondaryBackground.ignoresSafeArea(.all)
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
                        .environmentObject(appVM)
                        .environmentObject(marketVM)
                    SettingsView()
                        .tabItem{
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                        .environmentObject(appVM)
                }
                .accentColor(Color.custom.yellow)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
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
