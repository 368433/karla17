//
//  Custom Views and Modifiers.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import SwiftUI

struct LabeledTextField: View {
    var textfieldTitle: String
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>){
        self.textfieldTitle = title
        self._text = text
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 0){
            if !text.isEmpty {
                Text(textfieldTitle).font(.caption).foregroundColor(.blue)
            }
            TextField(textfieldTitle, text: $text)
        }
    }
}
