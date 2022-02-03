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
                    words = try Mnemonic.seed(mnemonic: mnemonic)
                    print(mnemonic)
                    
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
