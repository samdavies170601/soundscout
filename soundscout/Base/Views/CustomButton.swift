//
//  Primary Button.swift
//  soundscout
//
//  Created by Sam Davies on 06/08/2024.
//

import SwiftUI


/// A custom `ButtonStyle` used for the primary button.
/// >Tip: Call `.buttonStyle(PrimaryButton())` on any button to use this custom style.
struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(LinearGradient(colors: [Color(red: 250/255, green: 66/255, blue: 90/255), Color(red: 250/255, green: 26/255, blue: 55/255)], startPoint: .leading, endPoint: .trailing))
    }
}

/// A custom `ButtonStyle` used for the secondary button.
/// >Tip: Call `.buttonStyle(SecondaryButton())` on any button to use this custom style.
struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(LinearGradient(colors: [Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.6), Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.2)], startPoint: .leading, endPoint: .trailing))
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        VStack {
            Button(action: {}, label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: 318, maxHeight: 64)
            })
            .buttonStyle(PrimaryButton())
            Button(action: {}, label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: 318, maxHeight: 64)
            })
            .buttonStyle(SecondaryButton())
        }
    }
}
