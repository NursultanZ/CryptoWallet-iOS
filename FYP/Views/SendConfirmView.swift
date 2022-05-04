//
//  SendConfirmView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 4/5/2022.
//

import SwiftUI
import BigInt

struct SendConfirmView: View {
    
    @Environment(\.dismiss) var dismiss
    let parentPresentation: Binding<PresentationMode>?
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var walletCoinVM: WalletCoinViewModel
    
    var amount: Double? = 0.0
    var address: String
    
    @State var isError: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.custom.secondaryBackground.ignoresSafeArea(.all)
            VStack {
                List {
                    Section {
                        HStack {
                            Text("You Send")
                                .foregroundColor(Color.secondary)
                                .font(.caption)
                            Spacer()
                            Text(walletCoinVM.coin!.name)
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                        }
                        HStack {
                            Text("\(((walletCoinVM.coin?.currentPrice ?? 0.0) * amount!).currencyFormat2())")
                                .foregroundColor(Color.custom.yellow)
                                .font(.caption)
                            Spacer()
                            Text("\(amount!) " + walletCoinVM.coinSymbol)
                                .font(.caption)
                                .foregroundColor(Color.custom.mainText)
                        }
                        HStack {
                            Text("To")
                                .foregroundColor(Color.secondary)
                                .font(.caption)
                            Spacer()
                            Text(address)
                                .font(.caption)
                        }
                    }
                    .listRowBackground(Color.custom.background)
                    
                    Section{
                        HStack {
                            Text("Fee")
                                .font(.caption)
                                .foregroundColor(Color.secondary)
                            Spacer()
                            Text((appVM.gasPrice ?? 0.0).asFormattedString10() + " ETH | ")
                                .font(.caption)
                                .foregroundColor(Color.custom.mainText)
                            Text(((appVM.gasPrice ?? 0.0) * walletCoinVM.coin!.currentPrice).currencyFormat2())
                                .font(.caption)
                                .foregroundColor(Color.custom.mainText)
                        }
                    }
                    .listRowBackground(Color.custom.background)
                    

                }
                Button {
                    if (appVM.gasPrice! + amount! > walletCoinVM.holdings){
                        isError = true
                    }else {
                        DispatchQueue.global().async {
                            appVM.ethManager!.sendTransaction(amount: amount!, address: address)
                        }
                        self.parentPresentation?.wrappedValue.dismiss()
                        dismiss()
                    }
                } label: {
                    Text("Send")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .background(Color.custom.yellow)
                        .cornerRadius(30)
                        .padding([.leading, .trailing], 25)
                        .foregroundColor(Color.black)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .destructiveAction) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.custom.yellow)
                        .onTapGesture {
                            self.parentPresentation?.wrappedValue.dismiss()
                            dismiss()
                        }
                }
            })
            .alert("Not enough funds considering transaction fee.", isPresented: $isError) {
                Button("OK", role: .cancel){
                    isError = false
                }
                .foregroundColor(Color.custom.yellow)
            }
            .navigationTitle("Confirm")
        }
    }
}

struct SendConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        SendConfirmView(parentPresentation: nil, amount: 0.5, address: "0xBfAbE3711f01bf84aFeC78f0fBcF729579171949")
            .environmentObject(dev.appVM)
            .environmentObject(WalletCoinViewModel(coin: dev.coin, symbol: "ETH", holding: 0.5))
    }
}
