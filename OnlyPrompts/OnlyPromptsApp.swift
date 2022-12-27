//
//  OnlyPromptsApp.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import SwiftUI

@main
struct OnlyPromptsApp: App {
    @ObservedObject var viewModel: ShuffleViewModel = ShuffleViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
