//
//  DiagnosisSelectionView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import SwiftUI

struct DiagnosisSelectionRowView: View {
    @State private var showInfo = false
    var diagnosis: Diagnosis
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text(diagnosis.name)
                if showInfo{
                    Text(diagnosis.information).foregroundColor(.secondary)
                }
            }
            
            Spacer()
            Button(action: {showInfo.toggle()}) {
                Image(systemName: "info.circle")
            }
        }.contentShape(Rectangle())
    }
}

struct DiagnosisSelectionView: View {
    var availableDiagnosis: [Diagnosis] = [Diagnosis()]
    @State var primaryDiagnosis: Diagnosis? = nil
    @State var otherDiagnosis: Set<Diagnosis> = []
    @State private var showDiagnosisEdit = false
    
    var body: some View {
        List{
            //Selected Diagnoses
            Section{
                if otherDiagnosis.isEmpty {
                    Text("No diagnosis selected")
                }
                ForEach(Array(otherDiagnosis)) { diagnosis in
                    DiagnosisSelectionRowView(diagnosis: diagnosis)
                        .onTapGesture {
                            showDiagnosisEdit.toggle()
                        }
                        .sheet(isPresented: $showDiagnosisEdit) {
                            DiagnosisView(diagnosis: diagnosis)
                        }
                }
            } header: {
                Text("Selected diagnosis")
            }
            
            //Diagnosis list
            Section{
                ForEach(availableDiagnosis){dx in
                    DiagnosisSelectionRowView(diagnosis: dx)
                        .onTapGesture {
                            otherDiagnosis.insert(dx)
                        }
                }
            } header: {
                Text("Diagnosis database")
            }.headerProminence(.increased)
        }
        .toolbar{
            Button(action: {}, label: {Image(systemName: "magnifyingglass")})
            Button(action: {}, label: {Image(systemName: "plus")})
        }
    }
}


struct DiagnosisSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisSelectionView()
        DiagnosisSelectionView().preferredColorScheme(.dark)

    }
}
