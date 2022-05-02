//
//  AppViewModel.swift
//  FYP
//
//  Created by Nursultan Zakirov on 19/4/2022.
//

import Foundation
import KeychainAccess

class AppViewModel: ObservableObject {
    
    let keychain = SecureStorage(service: "com.nzakirov2.bank.FYP")
    
    @Published var isUnlocked: Bool = false
    @Published var launch: LaunchRouter
    
    @Published var isKeySaved: Bool = false
    
    init(){
        launch = .unlocked
        let words = keychain.checkData(key: "mnemonic")
        
        if (words) {
            isKeySaved = true
        }
        
    }
    
    enum LaunchRouter {
        case intro
        case unlocked
        case locked
    }
    
}
