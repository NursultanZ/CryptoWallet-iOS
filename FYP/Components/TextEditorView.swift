//
//  TextEditorView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 1/5/2022.
//

import SwiftUI

struct TextEditorView: View {
    
    @Binding var words: String
    
    init(text: Binding<String>){
        self._words = text
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().textContainerInset =
                 UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    var body: some View {
        TextEditor(text: $words)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .background(Color.custom.background)
            .accentColor(Color.custom.yellow)
            .cornerRadius(8)
            .foregroundColor(Color.custom.mainText)
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(text: .constant("Check"))
    }
}
