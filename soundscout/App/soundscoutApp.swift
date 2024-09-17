//
//  soundscoutApp.swift
//  soundscout
//
//  Created by Sam Davies on 06/08/2024.
//

import MusicKit
import SwiftUI

@main
struct soundscoutApp: App {
    
    @StateObject private var authorizer = Authorizer()
    
    var body: some Scene {
        WindowGroup {
            BlankView()
                .environmentObject(authorizer)
                .onAppear {
                    authorizer.setAuthorizationStatus()
                }
                .fullScreenCover(isPresented: $authorizer.isAuthorized.not) {
                    AuthorizationView()
                        .environmentObject(authorizer)
                }
        }
    }
    
}
