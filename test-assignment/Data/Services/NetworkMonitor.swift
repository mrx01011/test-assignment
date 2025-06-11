//
//  NetworkMonitor.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI
import Network

protocol NetworkMonitor: ObservableObject {
    var isConnected: Bool { get }
}

/// Default implementation of the `NetworkMonitor` protocol using `NWPathMonitor`.
///
/// This class observes changes in network connectivity status using
/// Apple's Network framework and publishes updates to the `isConnected` property
/// It runs on a background queue and delivers updates on the main thread.
class NetworkMonitorImpl: NetworkMonitor {
    private let monitor: NWPathMonitor = .init()
    private let queue = DispatchQueue(label: "NetworkMonitor_queue_working")
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.setStatus(connection: path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
    private func setStatus(connection: Bool) {
        Task { @MainActor in
            isConnected = connection
        }
    }
    
    deinit {
        monitor.cancel()
    }
}

private struct NetworkMonitorKey: DependencyKey {
    static var currentValue: any NetworkMonitor = NetworkMonitorImpl()
}

extension DependencyValues {
    var networkMonitor: any NetworkMonitor {
        get { Self[NetworkMonitorKey.self] }
        set { Self[NetworkMonitorKey.self] = newValue }
    }
}


