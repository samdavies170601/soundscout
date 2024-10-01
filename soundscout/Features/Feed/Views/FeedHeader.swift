//
//  FeedHeader.swift
//  soundscout
//
//  Created by Sam Davies on 18/08/2024.
//

import SwiftUI

struct FeedHeader: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(headerGradient)
                .frame(height: 200)
            HStack {
                Image("soundscout-logo")
            }
            .padding(.horizontal, 32)
        }
    }
    
    private var headerGradient: LinearGradient {
        LinearGradient(colors: [AppColor.black, AppColor.black.opacity(0)], startPoint: .top, endPoint: .bottom)
    }
    
}

#Preview {
    FeedHeader()
}
