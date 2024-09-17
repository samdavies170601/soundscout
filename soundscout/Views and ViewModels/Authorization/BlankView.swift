//
//  BlankView.swift
//  soundscout
//
//  Created by Sam Davies on 16/09/2024.
//

import SwiftUI

struct BlankView: View {
    
    @EnvironmentObject private var authorizer: Authorizer
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background
                    .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $authorizer.isAuthorized) {
                FeedView()
            }
        }
    }
}

#Preview {
    BlankView()
}
