//
//  ContentView.swift
//  FYP
//
//  Created by user on 26/1/2022.
//

import SwiftUI

struct ContentView: View {
    @State var words: Data?
    var body: some View {
        VStack{
            
            Button("Generate") {
                do{
                    let mnemonic = try Mnemonic.generateWords()
                    try Mnemonic.validatePhrase(words: mnemonic)
                    let seed = try Mnemonic.seed(mnemonic: mnemonic)
                    print(mnemonic)
                    print(seed.hexEncodedString())
                    let privKey = HDPrivateKey(seed: seed, xPrv: 0x0488ade4, xPub: 0x0488b21e)
                    print(privKey.serialized())
                    let newPrivKey = privKey.derive(at: UInt32(44), hardened: true).derive(at: UInt32(0), hardened: true).derive(at: UInt32(0), hardened: true)
                    print(newPrivKey.serialized())
                    print(newPrivKey.getPublicKey().serialized())
                    
                }catch {
                    print(error)
                }
            }
                .frame(width: 100, height: 40, alignment: .center)
                .foregroundColor(.black)
                .background(Color.yellow)
                .cornerRadius(15)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
