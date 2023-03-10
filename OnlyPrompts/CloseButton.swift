//
//  CloseButton.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import SwiftUI

struct CloseButton: View {
    #if os(iOS)
    private let xMarkSize: CGFloat = 14.0
    private let padding: CGFloat = 7.0
    #else
    private let xMarkSize: CGFloat = 9.0
    private let padding: CGFloat = 3.0
    #endif
    
    var body: some View {
        Image(systemName: "xmark")
            .font(.system(size: xMarkSize, weight: .bold))
            .foregroundColor(Color.black.opacity(0.6))
            .padding(.all, padding)
            .background(Color.primary.opacity(0.2))
            .clipShape(Circle())
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}
