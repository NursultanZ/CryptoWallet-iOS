//
//  ContentView.swift
//  FYP
//
//  Created by user on 26/1/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var appVM = AppViewModel()

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.custom.secondaryBackground)
    }
    
    var body: some View {
        ZStack{
            Color.custom.secondaryBackground.edgesIgnoringSafeArea(.all)
            AppView()
                .environmentObject(appVM)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
