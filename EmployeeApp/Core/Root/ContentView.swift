//
//  ContentView.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/20/24.
//

import SwiftUI
import Network

// Check for network and network conditions
//class NetworkMonitor: ObservableObject {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "NetworkMonitor")
//    @Published var isActive: Bool = false
//    @Published var isExpensive: Bool = false
//    @Published var isConstrained: Bool = false
//    @Published var connectionType = NWInterface.InterfaceType.other
//    
//    init() {
//        monitor.pathUpdateHandler = { path in
//            DispatchQueue.main.async {
//                // Checks for an active connection
//                self.isActive = path.status == .satisfied
//                // Checks if cellular or hotspot
//                self.isExpensive = path.isExpensive
//                // Checks if low data mode
//                self.isConstrained = path.isConstrained
//                
//                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
//                
//                // Assign the connection type
//                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
//            }
//        }
//        // Start the queue
//        monitor.start(queue: queue)
//    }
//}

struct ContentView: View {
    // Env object instances
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    // State variables
    @State private var errorTitle: String? = nil
    @State private var showError: Bool = false
    
    var body: some View {
        // Display view depending on if user is created
        if !networkMonitor.isActive {
            Text("No internet connection")
                .frame(maxWidth: 250, maxHeight: 50)
                .font(.system(size: 24))
                .padding()
        } else {
            Group {
                if viewModel.userSession != nil {
                    ProfileView()
                } else {
                    SignUpView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var viewModel = AuthViewModel()
    @StateObject static var networkMonitor = NetworkMonitor()
    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
            .environmentObject(networkMonitor)
    }
}
