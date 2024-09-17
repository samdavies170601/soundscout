//
//  Authorizer.swift
//  soundscout
//
//  Created by Sam Davies on 11/09/2024.
//

import Foundation
import MusicKit
import OSLog
import SwiftUI

fileprivate let logger = Logger(subsystem: "com.SamDavies.soundscout", category: "Authorizer")

final class Authorizer: ObservableObject {
    
    /// `true` if the current status is `.authorized`, `false` otherwise.
    @Published var isAuthorized = false
    
    /// The current status of the user (see ``MusicAuthorization.Status``).
    var currentStatus: MusicAuthorization.Status {
        MusicAuthorization.currentStatus
    }
    
    /// Request permission from the user to use MusicKit.
    /// - Returns: Returns the status of this request (see ``MusicAuthorization.Status``).
    @MainActor func requestMusicKitAuthorization() async -> MusicAuthorization.Status {
        return await MusicAuthorization.request()
    }
    
    /// Sets the bool `isAuthorized`.
    @MainActor func setAuthorizationStatus() {
        logger.info("currentStatus is \(self.currentStatus)")
        if currentStatus == .authorized {
            logger.info("isAuthorized is true")
            isAuthorized = true
        } else {
            logger.info("isAuthorized is false")
            isAuthorized = false
        }
    }
    
    /// Open the Settings app for the specific application.
    @MainActor func openSettings() async {
        let urlString = UIApplication.openSettingsURLString
        if let url = URL(string: urlString) {
            await UIApplication.shared.open(url)
        }
    }
    
}

extension Binding where Value == Bool {
    /// Used to negate a binding to a bool.
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
