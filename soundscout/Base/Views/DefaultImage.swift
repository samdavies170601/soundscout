//
//  DefaultImage.swift
//  soundscout
//
//  Created by Sam Davies on 17/08/2024.
//

import SwiftUI


/// Used in the cases that artwork is `nil`.
struct DefaultImage: View {
    
    let shape: DefaultImageShape
    
    var body: some View {
        ZStack {
            switch shape {
                case .circle:
                    Circle()
                        .foregroundStyle(AppColor.gray)
                case .rectangle:
                    Rectangle()
                        .foregroundStyle(AppColor.gray)
            }
            Text("?")
                .font(.interMedium18)
        }
    }
    
    /// The shape of the default image.
    enum DefaultImageShape {
        case circle
        case rectangle
    }
    
}

#Preview {
    DefaultImage(shape: .rectangle)
}
