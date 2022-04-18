//
//  SearchBarView.swift
//  FYP
//
//  Created by Nursultan Zakirov on 5/4/2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.custom.secondaryText)
            TextField("Search", text: $text)
                .foregroundColor(Color.custom.mainText)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.custom.mainText)
                        .padding()
                        .offset(x: 10)
                        .opacity(text.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            text = ""
                        },
                    alignment: .trailing
                )
                .disableAutocorrection(true)
        }
        .font(.headline)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.custom.background)
                .shadow(color: Color.custom.mainText.opacity(0.15), radius: 3, x: 0, y: 0)
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SearchBarView(text: .constant("Nurs"))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            SearchBarView(text: .constant(""))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
