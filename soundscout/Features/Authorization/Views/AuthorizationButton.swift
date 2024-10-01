//
//  WelcomeButton.swift
//  soundscout
//
//  Created by Sam Davies on 10/09/2024.
//

import SwiftUI

struct AuthorizationButton: View {
    
    let prompt: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                Text(prompt)
                    .font(.interSemiBold16)
                    .foregroundStyle(AppColor.white)
            }
        }
        .frame(maxWidth: 318, maxHeight: 64)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AuthorizationButton(prompt: "Link Apple Music", action: {})
    }
}
