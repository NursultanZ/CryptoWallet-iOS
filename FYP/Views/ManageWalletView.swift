//
//  ManageWalletView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 2/5/2022.
//

import SwiftUI

struct ManageWalletView: View {
    
    @EnvironmentObject private var appVM: AppViewModel
    
    @State var showRestore: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color.custom.secondaryBackground.ignoresSafeArea(.all)
            
            VStack {
                List {
                    Section("Current Wallet") {
                        ManageWalletListItem(imageName: "key.icloud", text: "Backup Phrase", color: Color.custom.yellow)
                        ManageWalletListItem(imageName: "trash", text: "Unlink Phrase", color: Color.custom.red)
                    }
                    
                    Section (footer: warningDesc){
                        ManageWalletListItem(imageName: "plus", text: "Create", color: Color.custom.yellow)
                        ManageWalletListItem(imageName: "square.and.arrow.down", text: "Restore", color: Color.custom.yellow)
                            .onTapGesture {
                                showRestore = true
                            }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Manage Wallet")
        }
        .sheet(isPresented: $showRestore) {
            RestoreKeyView()
                .environmentObject(appVM)
        }
        
    }
}

extension ManageWalletView {
    var warningDesc: some View {
        Text("Warning! Creating or restoring another wallet will result in the loss of the current one if existing.")
            .foregroundColor(Color.custom.secondaryText)
    }
}

struct ManageWalletListItem: View{
    
    var imageName: String
    var text: String
    var color: Color
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .frame(width: 25)
                .foregroundColor(color)
            Text(text)
                .foregroundColor(color)
            Spacer()
        }
        .background(Color.custom.background)
        .listRowBackground(Color.custom.background)
    }
}

struct ManageWalletView_Previews: PreviewProvider {
    static var previews: some View {
        ManageWalletView()
            .environmentObject(dev.appVM)
    }
}
