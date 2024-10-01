//
//  NetworkAlert.swift
//  soundscout
//
//  Created by Sam Davies on 26/09/2024.
//

import SwiftUI

struct NetworkAlert: View {
    
    let message: String
    
    var body: some View {
        ZStack {
            AppColor.black
                .opacity(0.5)
                .ignoresSafeArea()
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(AppColor.black)
                    .blur(radius: 4)
                RoundedRectangle(cornerRadius: 20)
                    .modifier(ClearBackground())
                VStack {
                    Text(message)
                        .font(.interMedium14)
                        .foregroundStyle(AppColor.white)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
            }
            .frame(width: 366, height: 83)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    NetworkAlert(message: "")
}
