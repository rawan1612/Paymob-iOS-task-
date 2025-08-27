//
//  NetworkMonitor.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 27/08/2025.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    
    var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
