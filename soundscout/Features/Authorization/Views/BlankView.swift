//
//  BlankView.swift
//  soundscout
//
//  Created by Sam Davies on 16/09/2024.
//

import SwiftUI

struct BlankView: View {
    
    @EnvironmentObject private var authorizer: Authorizer
    @EnvironmentObject private var feedViewModel: FeedViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background
                    .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $authorizer.isAuthorized) {
                FeedView()
                    .environmentObject(feedViewModel)
            }
        }
    }
}

#Preview {
    BlankView()
}
