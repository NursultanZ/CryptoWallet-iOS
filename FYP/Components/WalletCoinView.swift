import SwiftUI

struct WalletCoinView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var walletCoinVM: WalletCoinViewModel
    
    @State var showButtons: Bool = false
    @State var showSend: Bool = false
    @State var showReceive: Bool = false
    @State var errorString: String = ""
    @State var isError: Bool = false
    
    var address: String
    
    var body: some View {
        Section {
            HStack {
                Image(walletCoinVM.coinSymbol.lowercased())
                    .resizable()
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading){
                    Text(walletCoinVM.coinSymbol)
                        .foregroundColor(Color.custom.mainText)
                    
                    HStack {
                        Text(walletCoinVM.coin != nil ? walletCoinVM.coin!.currentPrice.currencyFormat6() : "---")
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                        
                        Text(walletCoinVM.coin != nil ? "\(walletCoinVM.coin!.priceChangePercentage24H?.asFormattedString() ?? "0.00")%" : "---")
                            .foregroundColor((walletCoinVM.coin?.priceChangePercentage24H ?? 0.0) >= 0 ? Color.custom.green : Color.custom.red)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                VStack (alignment: .trailing){
                    Text(walletCoinVM.coin != nil ? "\((walletCoinVM.holdings * walletCoinVM.coin!.currentPrice).currencyFormat6())" : "---")
                        .foregroundColor(Color.custom.yellow)
                    Text("\(walletCoinVM.holdings.asFormattedString4())")
                        .foregroundColor(Color.custom.mainText)
                        .font(.caption)
                }
            }
            .frame(height: 50)
            .contentShape(Rectangle())
            .onTapGesture {
                showButtons = !showButtons
            }
            
            if (showButtons){
                HStack{
                    Spacer()
                    Button("Send") {
                        if(appVM.isLoading || appVM.ethManager == nil || walletCoinVM.coin == nil){
                            errorString = "Ethereum Manager is still loading. Please try again."
                            isError = true
                        }else {
                            showSend = true
                        }
                    }
                    .foregroundColor(Color.black)
                    .frame(width: 120, height: 40)
                    .background(Color.custom.yellow)
                    .cornerRadius(25)
                    
                    Button("Receive") {
                        if(appVM.isLoading || appVM.ethManager == nil  || walletCoinVM.coin == nil){
                            errorString = "Ethereum Manager is still loading. Please try again."
                            isError = true
                        }else {
                            showReceive = true
                        }
                    }
                    .foregroundColor(Color.custom.background)
                    .frame(width: 120, height: 40)
                    .background(Color.custom.mainText)
                    .cornerRadius(25)
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
                .frame(height: 50)
            }
        }
        .listRowBackground(Color.custom.background)
        .sheet(isPresented: $showReceive, content: {
            ReceiveView(symbol: walletCoinVM.coinSymbol, address: address)
        })
        .sheet(isPresented: $showSend, content: {
            SendView()
                .environmentObject(walletCoinVM)
                .environmentObject(appVM)
        })
        .alert(errorString, isPresented: $isError) {
            Button("OK", role: .cancel){
                isError = false
            }
            .foregroundColor(Color.custom.yellow)
        }
    
        
    }
}

struct WalletCoinView_Previews: PreviewProvider {
    static var previews: some View {
        WalletCoinView(address: "0x8583c4934ea1931771d0cc75f04e280ddb6705c4")
            .preferredColorScheme(.light)
            .environmentObject(dev.appVM)
            .environmentObject(WalletCoinViewModel(coin: dev.coin, symbol: "ETH", holding: 0.5))
    }
}
