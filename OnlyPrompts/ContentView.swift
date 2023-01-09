//
//  ContentView.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ActiveDay.date, ascending: false)],
        animation: .default)
    var usageHistory: FetchedResults<ActiveDay>
    @ObservedObject var viewModel: ShuffleViewModel = ShuffleViewModel()
    
    @State var selection: Int? = 1

    var body: some View {
        if cd_artPrompts.lists.count > 0 {
            return AnyView(
                NavigationView {
                    List {
                        NavigationLink(destination: DashboardView(todaysImagePromptIndex: cd_artPrompts.lists.count == 0 ? 0 : getTodaysImagePromptIndex()), tag: 1, selection: $selection) {
                            Label("Dashboard", systemImage: "speedometer")
                        }
                        NavigationLink(destination: ImagePromptsView(), tag: 2, selection: $selection) {
                            Label("Prompts", systemImage: "photo")
                        }
#if os(macOS)
                        // work around for crash caused by lazy loading on macOS
                        Text("\(cd_artPrompts.lists.count)")
                            .foregroundColor(.secondary)
                            .opacity(0.0)
#endif
                    }
                }
            )
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                reloadView()
            }
            return AnyView(ProgressView())
        }
    }
    
    private func getTodaysImagePromptIndex() -> Int {
        return getTotalDaysVerseOpened() % cd_artPrompts.lists.count
    }
    
    private func getTotalDaysVerseOpened() -> Int {
        let daysRequestedPrompt = usageHistory.filter { $0.requestedPrompt == true }
        return daysRequestedPrompt.count
    }
    
    func reloadView() {
        self.viewModel.shuffle()
    }
}
