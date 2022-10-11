//
//  DiagnosisView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import SwiftUI

struct DiagnosisView: View {
    @State var diagnosis: Diagnosis
    
    var body: some View {
        Form{
            LabeledTextField("Name", text: $diagnosis.name)
            LabeledTextField("ICD code", text: $diagnosis.icdCode)
            LabeledTextField("Information", text: $diagnosis.information)
        }
    }
}

struct DiagnosisView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisView(diagnosis: Diagnosis())
    }
}
