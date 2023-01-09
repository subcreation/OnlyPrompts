//
//  DashboardView.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 1/8/23.
//

import SwiftUI

struct DashboardView: View {
    @State var showVisualModal = false
    var todaysImagePromptIndex: Int
    
    var body: some View {
        visualPromptView
    }
    
    var visualPromptView: some View {
        let imagePrompt = cd_artPrompts.lists[todaysImagePromptIndex]
        return VStack {
            HStack {
                Text("Today's Visual Prompt")
                Spacer()
                Button(action:  { showVisualModal = true }) {
                    Image(systemName: "photo")
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            AsyncImage(url: imagePrompt.imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    ZStack {
                        Color.black
                        Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0)
                            .foregroundColor(.red)
                    }
                } else {
                    ZStack {
                        Color.black
                        ProgressView()
                    }
                }
            }
#if os(macOS)
            .frame(minWidth: 160.0, maxWidth: 250.0, minHeight: 120.0, idealHeight: 180.0, maxHeight: 180.0, alignment: .center)
#else
            .frame(minWidth: 160.0, idealWidth: 250.0, maxWidth: .infinity, minHeight: 120.0, idealHeight: 180.0, maxHeight: .infinity, alignment: .center)
#endif
            .cornerRadius(10.0)
            .sheet(isPresented: $showVisualModal) {
                VStack {
                    HStack {
                        CloseButton()
                            .padding(16.0)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showVisualModal = false
                                }
                            }
                        Spacer()
                    }
                    ImagePromptDetailView(action: { }, artPrompt: imagePrompt)
#if os(macOS)
                        .frame(width: (NSScreen.main?.visibleFrame.width ?? 1024.0) - 100.0, height: (NSScreen.main?.visibleFrame.height ?? 1024.0) - 100.0)
#endif
                }
            }
            .onTapGesture {
                showVisualModal = true
            }
        }
#if os(macOS)
        .frame(maxWidth: 250)
#endif
    }
}
