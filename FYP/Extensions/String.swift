//
//  String.swift
//  FYP
//
//  Created by Nursultan Zakirov on 13/4/2022.
//

import Foundation

extension String {
    
    var removedHTMLCode: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
