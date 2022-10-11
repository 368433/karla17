//
//  WorklistView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import SwiftUI

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
            .navigationTitle(worklist.name ?? "Worklist")
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

struct WorklistView_Previews: PreviewProvider {
    static var previews: some View {
        WorklistView()
        WorklistView().preferredColorScheme(.dark)
    }
}
