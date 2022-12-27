//
//  ImagePromptDetailView.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import SwiftUI

struct ImagePromptDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) var colorScheme
    #if os(iOS)
    private let isIOS = true
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    #else
    private let isIOS = false
    #endif
    @State private var mouseOver = false
    @State private var tapped = false
    @State var imageSize: CGSize = .zero
    
    var action: () -> Void
    var artPrompt: ArtPrompt? = nil
    
    @ViewBuilder
    var body: some View {
#if os(iOS)
        ZStack(alignment: .topLeading) {
            GeometryReader { geo in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        AsyncImage(url: artPrompt?.imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if phase.error != nil {
                                Color.red
                            } else {
                                Color.gray
                            }
                        }
                        Spacer()
                        VStack {
                            HStack {
                                Text(.init("\(artPrompt?.credit ?? "")"))
                                    .accentColor(Color.accentColor)
                                    .padding(.all, 10)
                                Spacer()
                                if verticalSizeClass == .compact {
                                    Button(action: {
                                        startWriting()
                                    }) {
                                        Label("Start Writing", systemImage: "square.and.pencil")
                                    }
                                    .tint(Color.accentColor)
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.large)
                                    .padding(.all, 10)
                                }
                            }
                            if verticalSizeClass == .regular {
                                Button(action: {
                                    startWriting()
                                }) {
                                    Label("Start Writing", systemImage: "square.and.pencil")
                                        .frame(maxWidth: geo.size.width)
                                }
                                .tint(Color.accentColor)
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .padding(.all, 10)
                            }
                            let botURL = NSLocalizedString("https://chats.landbot.io/v3/H-1098465-JZSTNU3QPUQNDNVN/index.html", comment: "Url to a localized bot for providing prompt feedback")
                            let fullURL = "\(botURL)?title=\(removeMarkdownURL(from: artPrompt?.credit ?? ""))"
                            let urlWithTitleEncoded = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            Link("Give Feedback", destination: URL(string: urlWithTitleEncoded ?? "")!)
                                .accentColor(Color.accentColor)
                                .padding(.all, 10)
                        }
                        .frame(maxWidth: 400)
                        .cornerRadius(10.0)
                        .padding(16)
                    }
                    Spacer()
                }
            }
        }
#else
        ZStack(alignment: .topLeading) {
            GeometryReader { geo in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        AsyncImage(url: artPrompt?.imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if phase.error != nil {
                                Color.red
                            } else {
                                Color.gray
                            }
                        }
                        Spacer()
                        VStack {
                            HStack {
                                Text(.init("\(artPrompt?.credit ?? "")"))
                                    .accentColor(Color.accentColor)
                                    .padding(.all, 10)
                                Spacer()
                                Button(action: {
                                    startWriting()
                                }) {
                                    Label("Start Writing", systemImage: "square.and.pencil")
                                }
                                .tint(Color.accentColor)
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .padding(.all, 10)
                            }
                            let botURL = NSLocalizedString("https://chats.landbot.io/v3/H-1098465-JZSTNU3QPUQNDNVN/index.html", comment: "Url to a localized bot for providing prompt feedback")
                            let fullURL = "\(botURL)?title=\(removeMarkdownURL(from: artPrompt?.credit ?? ""))"
                            let urlWithTitleEncoded = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            Link("Give Feedback", destination: URL(string: urlWithTitleEncoded ?? "")!)
                                .accentColor(Color.accentColor)
                                .padding(.all, 10)
                        }
                        .frame(maxWidth: 400)
                        .cornerRadius(10.0)
                        .padding(16)
                    }
                    Spacer()
                }
            }
        }
#endif
    }
    
    func startWriting() -> Void {
        action()
        presentationMode.wrappedValue.dismiss()
    }
    
    func removeMarkdownURL(from str: String) -> String {
        return str.replacingOccurrences(of: "\\[|\\]", with: "", options: [.regularExpression]).replacingOccurrences(of: "\\([^()]*\\)", with: "", options: [.regularExpression])
    }
}
