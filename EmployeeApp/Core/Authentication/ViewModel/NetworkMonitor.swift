//
//  NetworkCheck.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/23/24.
//

import Foundation
import Network

@MainActor
class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isActive: Bool = false
    @Published var isExpensive: Bool = false
    @Published var isConstrained: Bool = false
    @Published var connectionType = NWInterface.InterfaceType.other
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                // Checks for an active connection
                self.isActive = path.status == .satisfied
                // Checks if cellular or hotspot
                self.isExpensive = path.isExpensive
                // Checks if low data mode
                self.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                
                // Assign the connection type
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        // Start the queue
        monitor.start(queue: queue)
    }
}
