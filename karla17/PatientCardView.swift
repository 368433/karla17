//
//  PatientCardView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-09.
//

import SwiftUI

struct KarlaImages {
    var workcard = "note.text"
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

struct Diagnosis {
    var name = "Pneumonia"
    var icdCode = "1324"
}

struct Visit {
    var date = Date()
    var patient: Patient? = nil
    var diagnosis: Diagnosis? = nil
}

struct WorkCard: Identifiable {
    var id = UUID()
    var patient: Patient? = nil
    var diagnosis: Diagnosis? = nil
    var visits: [Visit]? = nil
}

struct WorkList: Identifiable {
    var id = UUID()
    var name: String?
    var dateCreatetd: Date?
    var workCards: [WorkCard] = [WorkCard(), WorkCard()]
}

struct WorklistRowView: View {
    @State private var showFullCard = false
    
    var workcard: WorkCard
    var body: some View{
        HStack{
            Button { showFullCard.toggle()} label: {Image(systemName: "plus.diamond").font(.title3)}.buttonStyle(.borderless)
                .sheet(isPresented: $showFullCard, content: {
                    WorkcardView()
                })
            Spacer()
            VStack(alignment: .leading){
                
                // Patient name and chart number
                HStack{
                    Text(workcard.patient?.name ?? "Missing patient name").lineLimit(1)
                    Spacer()
                    Text("#34232").foregroundColor(.secondary).font(.footnote)
                }
                
                // diagnosis label and room number
                HStack{
                    Text("diagnosis").lineLimit(2)
                    Spacer()
                    Text("234")
                }.foregroundColor(.secondary)
                
                // BUTTON LIST
                HStack{
                    Button("Add visit", action: {}).buttonStyle(.bordered).buttonBorderShape(.capsule)
                    Button("Skip", action: {}).buttonStyle(.bordered).buttonBorderShape(.capsule)
                }.font(.caption)
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

struct WorkcardView: View {
    @Environment(\.dismiss) var dismiss
    @State var status: CardStatus = .active
    @State private var patientCardVisible = false
    @State var patient: Patient = Patient()
    
    var body: some View {
        NavigationStack{
            List{
                //Patient card view
                Section {
                    DisclosureGroup(isExpanded: $patientCardVisible) {
                        LabeledTextField("Full name", text: $patient.name)
                        LabeledTextField("Chart #", text: $patient.chartNumber)
                            .keyboardType(.numberPad)
                        LabeledTextField("RAMQ number", text: $patient.ramqNumber)
                            .keyboardType(.namePhonePad)
                        LabeledTextField("Postal code", text: $patient.postalCode)
                            .keyboardType(.asciiCapableNumberPad)
                        LabeledTextField("Phone number", text: $patient.phoneNumber)
                            .keyboardType(.phonePad)
                        DatePicker("Date of birth", selection: $patient.dateOfBirth, displayedComponents: .date)
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
                                Text(patient.name.isEmpty ? "Missing name":patient.name).foregroundColor(.secondary)
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
                                Text("Chart #: \(patient.chartNumber)")
                                Text("RAMQ #: \(patient.ramqNumber)")
                            }.foregroundColor(.secondary)

                        }
                    }
                }
                
                //Medical condition view
                Section {
                    // DIAGNOSIS ROW
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
                
                //Flag toggle
                Toggle(isOn: Binding(projectedValue: .constant(true))) {
                    Label {
                        Text("Flag")
                    } icon: {
                        Image(systemName: "flag.square.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                }
                
                //Card status section
                Section{
                    Picker("Status", selection: $status) {
                        ForEach(CardStatus.allCases, id:\.self){ state in
                            Text(state.label)
                        }
                    }
                    Text("List")
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
    
    // MARK: - MODEL
    var worklist = WorkList()
    
    // MARK: - BODY
    var body: some View{
        NavigationStack {
            List(worklist.workCards, selection: $multiSelection){ card in
                WorklistRowView(workcard: card)
            }
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

struct WorkcardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkcardView()
        WorkcardView().preferredColorScheme(.dark)
    }
}
