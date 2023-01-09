//
//  ImagePromptsView.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 1/8/23.
//

import SwiftUI
import CoreData

struct ImagePromptsView: View {
    @Environment(\.colorScheme) var colorScheme
//    @ObservedObject var viewModel: ShuffleViewModel
    @State var selectedItem: ArtPrompt? = nil
    private let columnWidth: CGFloat = 150.0
    private let cornerRadius: CGFloat = 10.0
    private let mosaicSpacing: CGFloat = 10.0
    
    var body: some View {
        ZStack {
            ProgressView()
                .opacity(cd_artPrompts.lists.count > 0 ? 0.0 : 1.0)
            
            GeometryReader { geo in
                ScrollView {
                    HStack(alignment: .top, spacing: mosaicSpacing) {
                        ForEach((0..<Int(floor(geo.size.width / columnWidth))).reversed(), id: \.self) { c in
                            LazyVStack(spacing: mosaicSpacing) {
                                ForEach(getPromptsInColumns(by: Int(floor(geo.size.width / columnWidth)))[c]) { prompt in
                                    AsyncImage(url: prompt.imageURL) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(cornerRadius)
                                        } else if phase.error != nil {
                                            ZStack {
                                                Color.black
                                                    .frame(height: columnWidth)
                                                    .cornerRadius(cornerRadius)
                                                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30.0)
                                                    .foregroundColor(.red)
                                            }
                                        } else {
                                            ZStack {
                                                Color.black
                                                    .frame(height: columnWidth)
                                                    .cornerRadius(cornerRadius)
                                                ProgressView()
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        selectedItem = prompt
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .sheet(item: $selectedItem) { item in
                        VStack {
                            HStack {
                                CloseButton()
                                    .padding(16.0)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedItem = nil
                                        }
                                    }
                                Spacer()
                            }
                            ImagePromptDetailView(action: { print("Placeholder action: navigate to new poem") }, artPrompt: item)
                            #if os(macOS)
                                .frame(width: (NSScreen.main?.visibleFrame.width ?? 1024.0) - 100.0, height: (NSScreen.main?.visibleFrame.height ?? 1024.0) - 100.0)
                            #endif
                            .background(colorScheme == .dark ? Color(hex: 0x000000, opacity: 0.3) : Color(hex: 0xFFFFFF, opacity: 0.3))
                        }
                    }
                    .navigationTitle("Visual Prompts")
                }
            }
        }
    }
    
    func getPromptsInColumns(by column: Int) -> [[ArtPrompt]] {
        var result: [[ArtPrompt]] = []
        
        for i in 0..<column {
            var list: [ArtPrompt] = []
            cd_artPrompts.lists.forEach { prompt in
                let index = cd_artPrompts.lists.firstIndex { $0.id == prompt.id }
                
                if let index = index {
                    if (index+1) % column == i {
                        list.append(prompt)
                    }
                }
            }
            result.append(list)
        }
        return result
    }
}
