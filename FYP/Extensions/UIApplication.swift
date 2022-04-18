//
//  UIApplication.swift
//  FYP
//
//  Created by Nursultan Zakirov on 6/4/2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
