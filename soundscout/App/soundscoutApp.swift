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
    
    // Authorization
    @StateObject private var authorizer = Authorizer()
    
    // Network Monitoring
    @StateObject private var monitor = NetworkMonitor()
    
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
                .overlay {
                    if !monitor.isConnected {
                        NetworkAlert(message: monitor.alertMessage)
                    }
                }
        }
    }
}
