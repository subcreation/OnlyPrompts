//
//  OnlyPromptsApp.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import SwiftUI

@main
struct OnlyPromptsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
