//
//  PatientCardView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-09.
//

import SwiftUI
import CoreData

struct KarlaImages {
    static var workcard = "note.text"
    static var worklist = "list.bullet"
    static var worklistRound = "list.bullet.circle.fill"
}

// MARK: - DATA OBJECTS

//struct Patient: Identifiable, Hashable {
//    var id = UUID()
//    var name: String = "Missing name"
//    var dateOfBirth = Date()
//    var postalCode = ""
//    var phoneNumber = ""
//    var chartNumber = ""
//    var ramqNumber = ""
//}

//struct Visit: Hashable {
//    var date = Date()
//    var patient: Patient? = nil
//    var diagnosis: DiagnosisStruct? = nil
//}

struct DiagnosisStruct: Identifiable, Hashable {
    var id: String
    var name = ""
    var icdCode = "000"
    var information = ""
    
    init(){
        self.id = self.icdCode
    }
}

//struct WorkCard: Identifiable, Hashable {
//    var id = UUID()
//    var patient: Patient = Patient()
//    var primaryDiagnosis: DiagnosisStruct = DiagnosisStruct()
//    var diagnosisList: [DiagnosisStruct] = []
//    var visits: [Visit] = []
//    var cardFlagged = false
//    var status: CardStatus = .active
//    var room: String = ""
//    var worklistId: UUID? = nil
////    var workList: WorklistModel? = nil
//}

//struct WorkList: Identifiable, Hashable {
//    var id = UUID()
//    var name: String = ""
//    var dateCreatetd: Date?
//    var workCards: [WorkCard] = []
//    var listIcon = KarlaImages.worklistRound
//    var isPinned = false
//}



// MARK: - VIEWS

struct WorklistView: View {
    
    // MARK: - Local variables
    @State private var showWorkCard = false
    @State private var showNewWorkCard = false
    @State private var searchQuery =  ""
    
    // MARK: - MODEL
    var worklist: Worklist
    
    // MARK: - BODY
    var body: some View{
        NavigationStack {
            List{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        Button("All", action: {})
                        Button("to see", action: {})
                        Button("seen", action: {})
                        Button("Inactive", action: {})
                    }.buttonStyle(.bordered).buttonBorderShape(.capsule).font(.footnote)
                }
                ForEach(worklist.cardsList){ card in
                    WorklistRowView(workcard: card)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchQuery)
            .sheet(isPresented: $showWorkCard, content: {
                WorkcardView()
            })//.presentationDragIndicator(.visible)
            
            .navigationTitle(worklist.name.isEmpty ? "Worklist" : worklist.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button(action: {showNewWorkCard.toggle()}) {
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
            .sheet(isPresented: $showNewWorkCard) {
                WorkcardView()
            }
        }
    }
}

//struct NewWorklistEditorView: View {
//    @ObservedObject var worklistContainer: LandingDeckModel
//    @Environment(\.dismiss) var dismiss
//    @State var newList = Worklist()
//
//    let columns = [GridItem(.fixed(30))]
//
//    var body: some View {
//        NavigationStack{
//            Form {
//                // List name and large icon
//                VStack{
//                    Image(systemName: newList.listIcon)
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(.blue)
//                        .padding(.top)
//                    TextField("List Name", text: $newList.name)
//                        .font(.title)
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.center)
//                        .padding(.top)
//                        .textFieldStyle(.roundedBorder)
//                }.frame(height: 140)
//
//                // Color and icon selection
//                Section{
//                    Text("Color")
//                    Text("Icon")
//                }
//            }
//            .navigationTitle("New list")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar{
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", role: .cancel, action: {dismiss()})
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Done", action: {
//                        worklistContainer.lists.append(WorklistModel(from: newList))
//                        dismiss()
//                    }).disabled(newList.name.isEmpty)
//                }
//            }
//        }
//    }
//}

//struct ExistingWorklistEditorView: View {
//    @Binding var worklist: WorkList
//    @Environment(\.dismiss) var dismiss
//
//    let columns = [GridItem(.fixed(30))]
//
//    var body: some View {
//        NavigationStack{
//            Form {
//                // List name and large icon
//                VStack{
//                    Image(systemName: worklist.listIcon)
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(.blue)
//                        .padding(.top)
//                    TextField("List Name", text: $worklist.name)
//                        .font(.title)
//                        .fontWeight(.medium)
//                        .multilineTextAlignment(.center)
//                        .padding(.top)
//                        .textFieldStyle(.roundedBorder)
//                }.frame(height: 140)
//
//                // Color and icon selection
//                Section{
//                    Text("Color")
//                    Text("Icon")
//                }
//
//                Section {
//                    DatePicker(selection: Binding(projectedValue: .constant(Date())), displayedComponents: .date) {
//                        Label("Date created", systemImage: "calendar")
//                    }
//                }
//            }
//            .navigationTitle("List Info")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar{
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", role: .cancel, action: {dismiss()})
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Done", action: {
//                        // TODO: Save function
//                        dismiss()
//                    }).disabled(worklist.name.isEmpty)
//                }
//            }
//        }
//    }
//}

struct WorklistEditorForm: View {
    @Binding var worklist: Worklist

    var body: some View {
//        NavigationStack{
            Form {
                // List name and large icon
                VStack{
                    Image(systemName: worklist.listIcon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .padding(.top)
                    TextField("List Name", text: $worklist.name)
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                        .textFieldStyle(.roundedBorder)
                }.frame(height: 140)
                
                // Color and icon selection
                Section{
                    Text("Color")
                    Text("Icon")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
//        }
    }
}

struct WorklistEditorView: View {
    @State var worklist: Worklist
    var dataManager: DataManager? = nil
    @Environment(\.dismiss) var dismiss
    
    init(worklist: Worklist? = nil, dataManager: DataManager? = nil){
        self._worklist = worklist == nil ? State(initialValue: Worklist()):State(initialValue: worklist!)
        self.dataManager = dataManager
    }
    
    var body: some View {
        NavigationStack{
            WorklistEditorForm(worklist: $worklist)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel, action: {dismiss()})
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: {
                            // TODO: Save function
                            save()
                            dismiss()
                        }).disabled(worklist.name.isEmpty)
                    }
                }
                .navigationTitle("List Info")
        }
    }
    private func save(){
        if let dm = dataManager {
            dm.addNewList(worklist: worklist)
        }
    }
}

struct WorklistRowView: View {
    @ObservedObject var workcard: Workcard
    @FocusState private var focusedField: Bool
    @State private var showFullWorkcard = false
    
    var body: some View{
        HStack{
            VStack(spacing: 8){
                Menu {
                    Button(action: {showFullWorkcard.toggle()}) {
                        Label("Show full card", systemImage: "info.circle")
                    }
                    Divider()
                    Button("Add visit", action: {})
                    Button("See tomorrow", action: {})
                    Button("Update room", action: {})
                } label: {
                    Image(systemName: "plus.diamond").font(.headline)
                }
                if focusedField {
                    Button(action: {showFullWorkcard.toggle()}, label: {Image(systemName: "info.circle")})
                        .font(.headline)
                        .buttonStyle(.borderless)
                }
            }
            .sheet(isPresented: $showFullWorkcard) {
                WorkcardView()
            }

            VStack(alignment: .leading){
                
                // Patient name and chart number
                HStack{
                    TextField("Full name", text: $workcard.patient.name)
                        .lineLimit(1)
                        .focused($focusedField)
                    Spacer()
                    Text("#34232").foregroundColor(.secondary).font(.footnote)
                }
                
                // diagnosis label and room number
                HStack{
                    Text("Dx")
                    TextField("Primary diagnosis", text: $workcard.primaryDx)
                        .focused($focusedField)
                        .lineLimit(2)
                    Spacer()
                    TextField("Room", text: $workcard.room)
                        .frame(width: 55)
//                        .fixedSize()
                        .focused($focusedField)
                        .multilineTextAlignment(.trailing)
                }.foregroundColor(.secondary).font(.callout)
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

struct WorkcardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var patientCardVisible = false
    @State private var showDateAdmitted = false
    @State private var workcard: WorkCard = WorkCard()
    private var workList: WorklistModel? = nil
    
    init(addToWorklist: WorklistModel){
        self.workList = addToWorklist
        self.workcard.worklistId = addToWorklist.id
    }
    
    init(){
        
    }
    
    var body: some View {
        NavigationStack{
            List{
                //Patient card view
                Section (header: Spacer(minLength: 0)){
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
                        Label {
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Chart #: ")
                                    Text(workcard.patient.chartNumber.isEmpty ? "None" : workcard.patient.chartNumber)
                                }
                                HStack{
                                    Text("RAMQ #: ")
                                    Text(workcard.patient.ramqNumber.isEmpty ? "None" : workcard.patient.ramqNumber)
                                }
                            }
                        } icon: {
                            Image(systemName: "info")
                        }
                        .foregroundColor(.secondary)
                        .font(.callout)
                    }
                }
                
                //Medical condition view
                Section {
                    // DIAGNOSIS ROW
                    NavigationLink {
                        DiagnosisSelectionView()
                    } label: {
                        Label {
                            HStack{
                                Text("Diagnosis")
                                Spacer()
                                Text(workcard.primaryDiagnosis.name)
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
                    
                    // Room number row
                    Label {
                        HStack{
                            Text("Room")
                            Spacer()
                            TextField("current room", text: $workcard.room)
                                .fixedSize()
                                .multilineTextAlignment(.trailing)
                        }
                    } icon: {
                        Image(systemName: "bed.double.circle.fill").font(.title)
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
            .listStyle(.insetGrouped)
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        //remove association with list
                        workcard.worklistId = nil
                        // do not save
                        //dismiss
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        //save card to database
                        workList?.workCards.append(WorkCardModel())
                        //dismiss view
                        dismiss()
                    }.disabled(workcard.patient.name.isEmpty || workcard.patient.chartNumber.isEmpty)
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

struct WorkspaceView: View {
    var body: some View{
        Text("test")
    }
}

struct DiagnosisSelectionRowView: View {
    @State private var showInfo = false
    var diagnosis: DiagnosisStruct
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
    var availableDiagnosis: [DiagnosisStruct] = [DiagnosisStruct()]
    @State var primaryDiagnosis: DiagnosisStruct? = nil
    @State var otherDiagnosis: Set<DiagnosisStruct> = []
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

struct DiagnosisView: View {
    @State var diagnosis: DiagnosisStruct
    
    var body: some View {
        Form{
            LabeledTextField("Name", text: $diagnosis.name)
            LabeledTextField("ICD code", text: $diagnosis.icdCode)
            LabeledTextField("Information", text: $diagnosis.information)
        }
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

struct LandingWorklistRowView: View {
    var worklist: WorkList
    var body: some View{
        HStack{
            //Image
            Image(systemName: worklist.listIcon)
                .foregroundColor(.blue)
                .font(.title)
            //Name
            Text(worklist.name.isEmpty ? "No name" : worklist.name)
            Spacer()
            //Card count
            Text("\(worklist.workCards.count)").foregroundColor(.secondary)
//            Image(systemName: "chevron.right")
        }.contentShape(Rectangle())
    }
}

struct TestView: View {
    var body: some View {
        HStack{
            Text("Name")
            Spacer()
        }
    }
}

struct SplitViewTest: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showAddList = false
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationSplitView {
            ScrollView(.vertical){
                VStack{
                    DashboardPinnedLists(worklists: [WorkList(), WorkList(), WorkList()])
                        .padding([.horizontal,.top])
                    MainViewMyListsView()
                        .environmentObject(dataManager)
                }
            }
            .searchable(text: $searchQuery)
            .background(Color(.systemGroupedBackground))
            .toolbar{
                Button(action: {showAddList.toggle()}, label: {Image(systemName: "plus")})
                    .sheet(isPresented: $showAddList) {
                        WorklistEditorView(dataManager: dataManager)
                    }
                Menu {
                    Button(action: {}, label: {Text("test")})
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        } detail: {
            EmptyView()
        }

    }
}

struct MainBoardScrollView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showAddList = false
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                VStack{
                    DashboardPinnedLists(worklists: [WorkList(), WorkList(), WorkList()])
                        .padding([.horizontal,.top])
                    MainViewMyListsView()
                        .environmentObject(dataManager)
                }
            }
            .background(Color(.systemGroupedBackground))
            .toolbar{
                Button(action: {showAddList.toggle()}, label: {Image(systemName: "plus")})
                    .sheet(isPresented: $showAddList) {
                        WorklistEditorView(dataManager: dataManager)
                    }
                Menu {
                    Button(action: {}, label: {Text("test")})
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }.searchable(text: $searchQuery)
    }
}

struct MainViewMyListsView: View {
    @EnvironmentObject private var dataManager: DataManager

    //List height
    private var listHeight: CGFloat {
        return CGFloat(dataManager.listsDatabase.count * 45) + 65.0
    }
    
    var body: some View {
        List {
            Section {
                ForEach(Array(dataManager.listsDatabase)){ worklist in
                    NavigationLink {
                        WorklistView(worklist: worklist)
                    } label: {
                        LandingWorklistRowView(worklist: worklist)
                    }
                }
            } header: {
                Text("My lists")
            }.headerProminence(.increased)
        }.frame(minHeight: listHeight)
    }
}

struct LandingWorkView: View {
    
    @EnvironmentObject private var dataManager: DataManager
//    @ObservedObject var model = LandingDeckModel()
    @State private var showAddList = false
    var body: some View{
        NavigationStack{
            VStack{
                DashboardPinnedLists(worklists: [])
                    .padding(.horizontal)
                List{
                    Section {
                        ForEach(Array(dataManager.listsDatabase)){ worklist in
                            NavigationLink {
                                WorklistView(worklist: worklist)
                            } label: {
                                LandingWorklistRowView(worklist: worklist)
                            }
                        }
                    } header: {
                        Text("My lists")
                    }.headerProminence(.increased)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button(action: {showAddList.toggle()}, label: {Image(systemName: "plus")})
                    .sheet(isPresented: $showAddList) {
                        WorklistEditorView(dataManager: dataManager)
                    }
                Menu {
                    Button(action: {}, label: {Text("test")})
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct WorklistTileView: View {
    var worklist: WorkList
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "info.circle")
                    .foregroundColor(.red)
                Spacer()
                Text("23")
                    .fontWeight(.bold)
            }.font(.title)
            Spacer()
            Text("Dynacare".capitalized)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .lineLimit(1)

        }
        .padding()
        .background(.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 3)
        .frame(height: 90)
    }
}

struct DashboardPinnedLists: View {
    var worklists: [WorkList]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View{
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(worklists) { worklist in
                NavigationLink {
                    Text("test")
                } label: {
                    WorklistTileView(worklist: worklist)
                }
                .buttonStyle(.plain)
            }
        }
    }
}


// MARK: - PERSISTENCE LAYER

class ListManager: ObservableObject {
    @Published var workLists: Set<WorkList> = []
    
    init(){
        self.workLists = loadLists() // load them from memory
    }
    
    private func loadLists() -> Set<WorkList> {
        return []
    }
    
    func addNewList(worklist: WorkList){
        workLists.insert(worklist)
    }
    func removeList(worklist: WorkList){
        workLists.remove(worklist)
    }
}

// Landing view model
class ListDeck: ObservableObject {
    @Published var deck: [WorklistModel] = []
    init(){
        self.deck = getDefaultLists()
    }
    // Get default lists
    private func getDefaultLists() -> [WorklistModel]{
        return []
    }
}

// Worklist model
class WorklistModel: ObservableObject, Identifiable {
    
    // identifier
    var id = UUID()
    
    // object data
    @Published var worklistData = WorkList()
    
    // object relationships
    @Published var workCards: [WorkCardModel] = []
    
    init(from worklist: WorkList){
        self.worklistData = worklist
    }
    init(){
        
    }
    
    // MARK: Intents
    // Add card to list
    func add(_ workCard: WorkCardModel) -> Void {
        self.workCards.append(workCard)
        self.saveWorkList()
    }
    // Save list
    func saveWorkList(){
        
    }
    // Create card
    func getNewWorkCard() -> WorkCardModel {
        let newCard = WorkCardModel()
        newCard.content.worklistId = self.id
        self.add(newCard)
        return newCard
    }
    // Read/get gard
    // Update card
    // Delete card
    func delete(_ workCard: WorkCard) -> Void {
        self.workCards.removeAll { card in
            card.id == workCard.id
        }
        saveWorkList()
    }
}

class WorkCardModel: ObservableObject, Identifiable {
    var id = UUID()
    @Published var content = WorkCard()
//    @Published var patient: Patient = Patient()
//    @Published var primaryDiagnosis: Diagnosis = Diagnosis()
//    @Published var diagnosisList: [Diagnosis] = []
//    @Published var visits: [Visit] = []
//    @Published var cardFlagged = false
//    @Published var status: CardStatus = .active
//    @Published var room: String = ""
//    @Published var workList: WorklistModel? = nil
    
    init(){
        
    }
    init(from workcard: WorkCard){
        self.content = workcard
    }
}

class PatientModel: ObservableObject {
    
    @Published var patient: Patient
    init(patient: Patient){
        self.patient = patient
    }
}

class LandingDeckModel: ObservableObject {
    @Published var lists: [WorklistModel] = []
    func addNewList(){
        let newList = WorklistModel()
        lists.append(newList)
    }
}

class DataManager: ObservableObject {
    @Published var listsDatabase: Set<WorkList>
    @Published var patientsDatabase: Set<Patient>
    @Published var cardsDatabase: Set<WorkCard>
    init(){
        // for now initializing empty Set
        self.listsDatabase = []
        self.patientsDatabase = []
        self.cardsDatabase = []
    }
    
    func addNewList(worklist: WorkList){
        listsDatabase.insert(worklist)
    }
    func removeList(worklist: WorkList){
        listsDatabase.remove(worklist)
    }
}

// ---


struct WorkcardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkcardView()
        WorkcardView().preferredColorScheme(.dark)
        WorklistView(worklist: WorkList())
        ExistingWorklistEditorView(worklist: Binding(projectedValue: .constant(WorkList())))
    }
}
struct LandingWorkView_Previews: PreviewProvider {
    static let dataManager = DataManager()
    static var previews: some View{
        LandingWorkView()
            .environmentObject(dataManager)
        MainBoardScrollView()
            .environmentObject(dataManager)
    }
}
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
