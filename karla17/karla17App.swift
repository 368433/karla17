//
//  karla17App.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-08.
//

import SwiftUI

@main
struct karla17App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//            WorklistView(worklist: WorkList())
            LandingWorkView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
