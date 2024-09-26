//
//  NetworkMonitor.swift
//  soundscout
//
//  Created by Sam Davies on 26/09/2024.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    
    /// Store a `Bool` depending on the connection status of the user.
    @Published var isConnected = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    let alertMessage = "soundscout requires a connection to the Internet. Please enable WiFi or Cellular to continue listening."
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.isConnected = true
                } else {
                    self.isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
        
}
