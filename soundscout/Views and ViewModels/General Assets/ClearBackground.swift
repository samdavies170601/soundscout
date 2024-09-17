//
//  ClearBackground.swift
//  soundscout
//
//  Created by Sam Davies on 08/08/2024.
//

import SwiftUI

/// A custom view modifier used to create a clear background.
/// >Tip: Call `.modifier(ClearBackground())` to use this modifier.
struct ClearBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.6), Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.2)], startPoint: .leading, endPoint: .trailing))
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        RoundedRectangle(cornerRadius: 12)
            .frame(maxWidth: .infinity, maxHeight: 74)
            .modifier(ClearBackground())
            .padding(.horizontal, 32)
    }
}
