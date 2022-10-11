//
//  PatientCardView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-09.
//

import SwiftUI

struct KarlaImages {
    static var workcard = "note.text"
    static var worklist = "tray.full.fill"
}

struct Patient: Identifiable {
    var id = UUID()
    var name: String = ""
    var dateOfBirth = Date()
    var postalCode = ""
    var phoneNumber = ""
    var chartNumber = ""
    var ramqNumber = ""
}

struct Visit {
    var date = Date()
    var patient: Patient? = nil
    var diagnosis: Diagnosis? = nil
}

struct WorkCard: Identifiable, Diagnosed {
    var id = UUID()
    var patient: Patient = Patient()
    var primaryDiagnosis: Diagnosis? = nil
    var diagnosisList: [Diagnosis] = []
    var visits: [Visit] = []
    var cardFlagged = false
    var status: CardStatus = .active
}

struct WorkList: Identifiable {
    var id = UUID()
    var name: String?
    var dateCreatetd: Date?
    var workCards: [WorkCard] = [WorkCard(), WorkCard()]
}

struct WorklistRowView: View {
    var workcard: WorkCard
    var body: some View{
        HStack{
            Menu {
                Button("Add visit", action: {})
                Button("See tomorrow", action: {})
                Button("Update room", action: {})
            } label: {
                Image(systemName: "plus.diamond")
            }

            VStack(alignment: .leading){
                
                // Patient name and chart number
                HStack{
                    Text(workcard.patient.name).lineLimit(1)
                    Spacer()
                    Text("#34232").foregroundColor(.secondary).font(.footnote)
                }
                
                // diagnosis label and room number
                HStack{
                    Text("diagnosis").lineLimit(2)
                    Spacer()
                    Text("234")
                }.foregroundColor(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}

enum CardStatus: CaseIterable {
    case active, archived, transferred
    var label: String {
        switch self{
        case .active: return "Active"
        case .archived: return "Signed Off"
        case .transferred: return "Transferred"
        }
    }
}

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

struct WorkcardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var patientCardVisible = false
    @State private var showDateAdmitted = false
    @State private var workcard: WorkCard = WorkCard()
    
    var body: some View {
        NavigationStack{
            List{
                //Patient card view
                Section {
                    DisclosureGroup(isExpanded: $patientCardVisible) {
                        LabeledTextField("Full name", text: $workcard.patient.name)
                        LabeledTextField("Chart #", text: $workcard.patient.chartNumber)
                            .keyboardType(.numberPad)
                        LabeledTextField("RAMQ number", text: $workcard.patient.ramqNumber)
                            .keyboardType(.namePhonePad)
                        LabeledTextField("Postal code", text: $workcard.patient.postalCode)
                            .keyboardType(.asciiCapableNumberPad)
                        LabeledTextField("Phone number", text: $workcard.patient.phoneNumber)
                            .keyboardType(.phonePad)
                        DatePicker("Date of birth", selection: $workcard.patient.dateOfBirth, displayedComponents: .date)
                        DisclosureGroup {
                            Text("Add scan")
                        } label: {
                            Text("Health Card scan")
                        }
                    } label: {
                        Label {
                            HStack{
                                Text("Patient")
                                Spacer()
                                Text(workcard.patient.name.isEmpty ? "Missing name":workcard.patient.name).foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "person.crop.square.fill")
                                .font(.title)
                        }
                    }
                    if !patientCardVisible {
                        HStack{
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("Chart #: \(workcard.patient.chartNumber)")
                                Text("RAMQ #: \(workcard.patient.ramqNumber)")
                            }.foregroundColor(.secondary)
                        }.font(.subheadline)
                    }
                }
                
                //Medical condition view
                Section {
                    // DIAGNOSIS ROW
                    NavigationLink {
                        DiagnosisSelectionView(workcard)
                    } label: {
                        Label {
                            HStack{
                                Text("Diagnosis")
                                Spacer()
                                Text("a diagnosis")
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "heart.text.square.fill").font(.title).foregroundColor(.red)
                        }
                    }

                    // VISITS ROW
                    Label {
                        HStack{
                            Text("Visits")
                            Spacer()
                            Text("Last visit...").foregroundColor(.secondary)
                        }
                    } icon: {
                        Image(systemName: "square.text.square.fill").font(.title).foregroundColor(.yellow)
                    }
                }
                
                Section{
                    // Consulting physician
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Label {
                            Text("Consulting MD")
                        } icon: {
                            Image(systemName: "stethoscope.circle.fill").font(.title).foregroundColor(.mint)
                        }
                    }
                    
                    // Hospitalized date
                    Toggle(isOn: $showDateAdmitted) {
                        Label {
                            Text("Date admitted")
                        } icon: {
                            Image(systemName: "calendar").font(.title).foregroundColor(.purple)
                        }
                    }
                    if showDateAdmitted {
                        DatePicker("Select date", selection: Binding(projectedValue: .constant(Date())), displayedComponents: .date)
                    }
                    
                    //Flag toggle
                    Toggle(isOn: $workcard.cardFlagged) {
                        Label {
                            Text("Flag")
                        } icon: {
                            Image(systemName: "flag.square.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                // Scheduled
                Section {
                    DatePicker(selection: Binding(projectedValue: .constant(Date())), displayedComponents: .date) {
                        Label {
                            Text("Scheduled")
                        } icon: {
                            Image(systemName: "calendar.badge.clock").font(.title).foregroundColor(.green)
                        }
                    }
                } footer: {
                    Text("When is the card next expected to be seen")
                }

                
                //Card status section
                Section{
                    Picker("Status", selection: $workcard.status) {
                        ForEach(CardStatus.allCases, id:\.self){ state in
                            Text(state.label)
                        }
                    }
                    NavigationLink(destination: EmptyView()) {
                        Label {
                            Text("List")
                        } icon: {
                            Image(systemName: KarlaImages.worklist)
                        }
                    }
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: {dismiss()}) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {}) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

struct WorklistView: View {
    
    // MARK: - Local variables
    @State private var multiSelection = Set<UUID>()
    @State private var cardsPath: [WorkCard] = []
    @State private var showWorkCard = false
    
    // MARK: - MODEL
    var worklist = WorkList()
    
    // MARK: - BODY
    var body: some View{
        NavigationStack {
            List(worklist.workCards, selection: $multiSelection){ card in
                WorklistRowView(workcard: card)
                    .onTapGesture {
                        showWorkCard.toggle()
                    }
            }
            .sheet(isPresented: $showWorkCard, content: {
                WorkcardView()
            })
            .navigationTitle(worklist.name ?? "Workcards")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                Menu{
                    Button {} label: {
                        Label("Show list info", systemImage: "info.circle")
                    }
                    Button {} label: {
                        Label("Select workcards", systemImage: "checkmark.circle")
                    }
                    Button {} label: {
                        Menu {
                            Button("test", action: {})
                        } label: {
                            Label("Sort by", systemImage: "arrow.up.arrow.down")
                        }
                    }
                    Button(role: .destructive, action: {}) {
                        Label("Delete worklist", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct WorkspaceView: View {
    var body: some View{
        Text("test")
    }
}

struct PatientCardView: View {
    @State var patientName = ""
    @State var postalCode = ""
    @State var phoneNumber = ""
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    TextField("Full name", text: $patientName)
                    TextField("Chart #", text: $patientName)
                        .keyboardType(.numberPad)
                    TextField("RAMQ number", text: $patientName)
                        .keyboardType(.namePhonePad)
                }
                Section {
                    DatePicker("Date of birth", selection: Binding(projectedValue: .constant(Date())), displayedComponents: .date)
                }
                Section {
                    TextField("Postal code", text: $postalCode)
                        .keyboardType(.asciiCapableNumberPad)
                    TextField("Phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Section {
                    DisclosureGroup {
                        Text("Add scan")
                    } label: {
                        Text("Health Card scan")
                    }

                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: {}) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {}) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

struct Worklist_Previews: PreviewProvider {
    static var previews: some View {
        WorklistView()
        WorklistView().preferredColorScheme(.dark)
    }
}

struct DiagnosisSelectionVIew_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisSelectionView(WorkCard())
        DiagnosisSelectionView(WorkCard()).preferredColorScheme(.dark)
    }
}

struct WorkcardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkcardView()
        WorkcardView().preferredColorScheme(.dark)
    }
}
