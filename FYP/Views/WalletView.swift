import SwiftUI

struct WalletView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var marketVM: MarketViewModel
    
    @State var showCreateKey: Bool = false
    @State var showRestoreKey: Bool = false
    @State var isPressed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                VStack {
                    if(appVM.isKeySaved){
                        
                        if(appVM.isLoading || appVM.ethManager == nil){
                            ProgressView()
                        }else {
                            List {
                                
                                Section {

                                    WalletCoinView(address: appVM.ethManager!.getAddress())
                                        .environmentObject(appVM)
                                        .environmentObject(WalletCoinViewModel(coin: marketVM.getCoin(symbol: "ETH"), symbol: "ETH", holding: Double(appVM.balance ?? "0.0") ?? 0.0))
                                    
                                }
                                
                            }
                            .listStyle(.insetGrouped)
                        }
                        
                    }else {
                        Spacer()
                        Spacer()
                        
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.custom.secondaryText)
                        FieldCaption(text: "No wallet yet")
                        
                        Spacer()
                        Spacer()
                        
                        Button {
                            showCreateKey = true
                        } label: {
                            Text("Create")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .background(Color.custom.yellow)
                                .cornerRadius(30)
                                .padding([.leading, .trailing], 25)
                                .foregroundColor(Color.black)
                        }
                        
                        Button {
                            showRestoreKey = true
                        } label: {
                            Text("Restore")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .background(Color.custom.secondaryText)
                                .cornerRadius(30)
                                .padding([.leading, .trailing], 25)
                                .foregroundColor(Color.custom.background)
                        }
                        
                        Spacer()
                        
                    }
                }
                .refreshable {
                    appVM.updateBalance()
                    marketVM.reloadData()
                }
                .navigationTitle("Wallet")
            }
        }
        .sheet(isPresented: $showRestoreKey) {
            RestoreKeyView()
        }
        .sheet(isPresented: $showCreateKey) {
            CreateKeyView()
        }
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
            .environmentObject(dev.appVM)
            .environmentObject(dev.marketVM)
    }
}
