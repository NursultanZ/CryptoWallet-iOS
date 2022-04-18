//
//  Color.swift
//  FYP
//
//  Created by Nursultan Zakirov on 25/3/2022.
//

import Foundation
import SwiftUI

extension Color {
    static let custom = ColorTheme()
}

struct ColorTheme {
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let background = Color("BackgroundColor")
    let secondaryText = Color("SecondaryText")
    let mainText = Color("MainText")
    let secondaryBackground = Color("SecondaryBackgroundColor")
    let yellow = Color("Yellow")
}
