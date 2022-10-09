//
//  PatientCardView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-09.
//

import SwiftUI

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
struct PatientCardView2: View {
    @State var patientName = ""
    @State var postalCode = ""
    @State var phoneNumber = ""
    @State var status: CardStatus = .active
    
    var body: some View {
        NavigationStack{
            List{
                Group {
                    DisclosureGroup {
                        TextField("Full name", text: $patientName)
                        TextField("Chart #", text: $patientName)
                            .keyboardType(.numberPad)
                        TextField("RAMQ number", text: $patientName)
                            .keyboardType(.namePhonePad)
                        
                        TextField("Postal code", text: $postalCode)
                            .keyboardType(.asciiCapableNumberPad)
                        TextField("Phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                        DatePicker("Date of birth", selection: Binding(projectedValue: .constant(Date())), displayedComponents: .date)
                        DisclosureGroup {
                            Text("Add scan")
                        } label: {
                            Text("Health Card scan")
                        }
                        
                    } label: {
                        Label {
                            HStack{
                                Text("Name")
                                Spacer()
                                Text("Bobby").foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "person.crop.square.fill")
                                .font(.title)
                        }
                    }
                }
                Group {
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
                Group {
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
                Toggle(isOn: Binding(projectedValue: .constant(true))) {
                    Label {
                        Text("Flag")
                    } icon: {
                        Image(systemName: "flag.square.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                }
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
                    Button(role: .cancel, action: {}) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {}) {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {}) {
                        Text("+ Visit")
                    }
                }
            }
        }
    }
}

struct PatientCardView_Previews: PreviewProvider {
    static var previews: some View {
        PatientCardView2()
    }
}

struct PatientCardView_PreviewsDark: PreviewProvider {
    static var previews: some View {
        PatientCardView2().preferredColorScheme(.dark)
    }
}
