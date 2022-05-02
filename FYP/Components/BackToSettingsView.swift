//
//  BackToSettingsView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 2/5/2022.
//

import SwiftUI

struct BackToSettingsView: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            HStack (spacing: 1){
                Image(systemName: "chevron.left")
                Text("Settings")
            }
            .foregroundColor(Color.custom.yellow)
        }
    }
}
