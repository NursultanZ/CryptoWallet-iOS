import SwiftUI

struct SendView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentation: Binding<PresentationMode>

    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var walletCoinVM: WalletCoinViewModel
    
    @State var amount: String = ""
    @State var address: String = ""
    
    @State var isError: Bool = false
    
    @State var errorString: String = ""
    
    @State var isLinkActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                if (appVM.ethManager != nil) {
                    VStack {
                        List {
                            Section(header: SendHeader){
                                NumberField
                                Text(((Double(amount) ?? 0.0) * (walletCoinVM.coin?.currentPrice ?? 0.0)).currencyFormat2())
                            }
                            .listRowBackground(Color.custom.background)
                            
                            Section (header: Text("Recipient Address")){
                                HStack {
                                    TextEditor(text: $address)
                                        .background(Color.custom.background)
                                        .accentColor(Color.custom.yellow)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                    
                                    if(address != ""){
                                        Button {
                                            address = ""
                                        } label: {
                                            ClearButton
                                        }

                                    }
                                    
                                    Button {
                                        address = UIPasteboard.general.string ?? ""
                                    } label: {
                                        Text("Paste")
                                            .foregroundColor(Color.custom.yellow)
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                            }
                            .listRowBackground(Color.custom.background)
                        }
                        .listStyle(.insetGrouped)
                        
                        
                        NavigationLink (destination: SendConfirmView(parentPresentation: presentation, amount: Double(amount), address: address)
                            .environmentObject(appVM)
                            .environmentObject(walletCoinVM), isActive: $isLinkActive) {
                            Text("Next")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .background(Color.custom.yellow)
                                .cornerRadius(30)
                                .padding([.leading, .trailing], 25)
                                .foregroundColor(Color.black)
                                .onTapGesture {
                                    if(checkAmount()){
                                        if(address == "" || !checkAddress(add: address)){
                                            errorString = "Entered address is not valid. Please enter correct recipient address."
                                            isError = true
                                            isLinkActive = false
                                        }else {
                                            appVM.updateGasPrice()
                                            isLinkActive = true
                                        }
                                    }
                                }
                        }
                        Spacer()

                    }
                    .navigationTitle("Send \(walletCoinVM.coinSymbol)")
                    .toolbar {
                        ToolbarItem(placement: .destructiveAction) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.custom.yellow)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Image(walletCoinVM.coinSymbol.lowercased())
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }else {
                    ProgressView()
                }
            }
            .alert(errorString, isPresented: $isError) {
                Button("OK", role: .cancel){
                    isError = false
                }
                .foregroundColor(Color.custom.yellow)
            }
        }.accentColor(Color.custom.yellow)
        
    }
    
    func checkAmount() -> Bool{
        if(amount != ""){
            if let safeAmount = Double(amount){
                if(safeAmount > walletCoinVM.holdings){
                    errorString = "You do not have sufficient funds. Please consider the transaction fee as well."
                    isError = true
                    isLinkActive = false
                    return false
                }else {
                    return true
                }
            }else {
                errorString = "Please correct your sending amount!"
                isError = true
                isLinkActive = false
                return false
            }
        }else {
            errorString = "Please enter the amount you want to send."
            isError = true
            isLinkActive = false
            return false
        }
        isLinkActive = false
        return false
    }
    
    func checkAddress(add: String) -> Bool{
        return appVM.ethManager!.checkAddress(address: add)
    }
}

extension SendView {
    
    var ClearButton: some View {
        Image(systemName: "x.circle")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(Color.secondary)
    }
    
    var NumberField: some View {
        HStack {
            TextField("0", text: $amount)
                .background(Color.custom.background)
                .foregroundColor(Color.custom.mainText)
                .accentColor(Color.custom.yellow)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.decimalPad)
            
            if(amount != ""){
                Button {
                    amount = ""
                } label: {
                    ClearButton
                }

            }
        }
    }
    
    var SendHeader: some View {
        HStack{
            Text("Available Balance")
                .foregroundColor(Color.secondary)
                .font(.caption)
            Spacer()
            Text("\(walletCoinVM.holdings) \(walletCoinVM.coinSymbol)")
                .foregroundColor(Color.custom.mainText)
                .font(.caption)
        }
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
        SendView()
            .environmentObject(dev.appVM)
            .environmentObject(WalletCoinViewModel(coin: dev.coin, symbol: "ETH", holding: 0.5))
    }
}
