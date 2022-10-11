//
//  DiagnosisSelectionView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import SwiftUI

struct DiagnosisSelectionRowView: View {
    var diagnosis: Diagnosis
//    var isSelected: Bool
    var body: some View{
        HStack{
            Text(diagnosis.name)
            Spacer()
            Button(action: {}) {
                Image(systemName: "plus.square")
            }
        }.contentShape(Rectangle())
    }
}

struct DiagnosisSelectionView: View {
    @State private var multiSelection = Set<UUID>()
    private var availableDiagnosis: [Diagnosis] = [Diagnosis()]
    @State private var selectedDiagnosis: [Diagnosis] = []
    
    init(_ diagnosed: Diagnosed){
        self.selectedDiagnosis = diagnosed.diagnosisList
    }
    
    var body: some View {
        List{
            //Selected Diagnoses
            Section{
                if selectedDiagnosis.isEmpty {
                    Text("No diagnosis selected")
                }
                ForEach(selectedDiagnosis) { diagnosis in
                    DiagnosisSelectionRowView(diagnosis: diagnosis)
                }
            } header: {
                Text("Selected diagnosis")
            }
            
            //Diagnosis list
            Section{
                ForEach(availableDiagnosis){dx in
                    DiagnosisSelectionRowView(diagnosis: dx)
                        .onTapGesture {
                            selectedDiagnosis.append(dx)
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
        DiagnosisSelectionView(WorkCard())
        DiagnosisSelectionView(WorkCard()).preferredColorScheme(.dark)

    }
}
