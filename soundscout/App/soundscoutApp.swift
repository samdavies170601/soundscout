//
//  soundscoutApp.swift
//  soundscout
//
//  Created by Sam Davies on 06/08/2024.
//

import MusicKit
import OSLog
import SwiftUI

fileprivate let logger = Logger(subsystem: "soundscout", category: "soundscoutApp")

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //@StateObject var feedViewModel = FeedViewModel()
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

@main
struct soundscoutApp: App {
    
    // Authorization
    @StateObject private var authorizer = Authorizer()
    
    // Network Monitoring
    @StateObject private var monitor = NetworkMonitor()
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var feedViewModel = FeedViewModel()
    
    // App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            BlankView()
                .environmentObject(authorizer)
                .environmentObject(feedViewModel)
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
                .onChange(of: scenePhase) { _, phase in
                    if phase == .background {
                        feedViewModel.saveFeedProgress()
                        logger.info("scenePhase is .background")
                    }
                }
        }
    }
}
