//
//  CreateKeyView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 2/5/2022.
//

import SwiftUI

struct CreateKeyView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var showSalt: Bool = false
    @State var salt: String = ""
    @State var confirm: String = ""
    @State var numberOfWords: Int = 12
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.custom.secondaryBackground.ignoresSafeArea(.all)
                VStack {
                    
                    HStack{
                        Image(systemName: "tray.and.arrow.up")
                            .foregroundColor(Color.custom.yellow)
                            .frame(width: 25)
                        Text("Mnemonic")
                        Spacer()
                        Menu {
                            Button {
                                numberOfWords = 12
                            } label: {
                                Text("12 words")
                            }
                            Button {
                                numberOfWords = 24
                            } label: {
                                Text("24 words")
                            }
                        } label: {
                            HStack{
                                Text("\(numberOfWords) words")
                                    .foregroundColor(Color.custom.mainText)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.custom.secondaryText)
                            }
                        }

                    }
                    .padding()
                    .frame(height: 50)
                    .background(Color.custom.background)
                    .cornerRadius(8)
                    .padding([.top, .bottom], 15)
                    
                    
                    ToggleSalt
                    
                    if (showSalt) {
                        PassphraseField
                        ConfirmField
                        FieldCaption(text: "Passhprase, also known as salt, adds an additional security layer to the wallet. It can be any phrase that consists of letters.")
                        FieldCaption(text: "To restore the wallet, the user must enter the mnemonic phrase along with the passphrase that was generated by the user.")
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .navigationTitle("New Wallet")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.custom.yellow)
                            .onTapGesture {
                                dismiss()
                            }
                            
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Text("Create")
                            .foregroundColor(Color.custom.yellow)
                            .onTapGesture {
                                
                            }
                    }
                })
            }
        }
        
    }
}

extension CreateKeyView {
    
    var PassphraseField: some View {
        TextField("Passphrase", text: $salt)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .frame(height: 50)
            .background(Color.custom.background)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.2)
                .foregroundColor(Color.custom.secondaryText))
            .foregroundColor(Color.custom.mainText)
            .accentColor(Color.custom.yellow)
    }
    
    var ConfirmField: some View {
        TextField("Confirm", text: $confirm)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .frame(height: 50)
            .background(Color.custom.background)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.2)
                .foregroundColor(Color.custom.secondaryText))
            .foregroundColor(Color.custom.mainText)
            .accentColor(Color.custom.yellow)
    }
    
    var ToggleSalt: some View {
        HStack{
            Image(systemName: "key")
                .foregroundColor(Color.custom.yellow)
                .frame(width: 25)
            Toggle("Passphrase", isOn: $showSalt)
                .tint(Color.custom.yellow)
        }
        .padding()
        .frame(height: 50)
        .background(Color.custom.background)
        .cornerRadius(8)
        .padding([.top, .bottom], 15)
    }
}

struct CreateKeyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateKeyView()
    }
}
