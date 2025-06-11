//
//  TabBarViewModel.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI
import Combine

@Observable
final class TabBarViewModel {
    // MARK: Dependency
    @ObservationIgnored
    @Dependency(\.networkMonitor)
    private var networkMonitor: any NetworkMonitor

    //MARK: Properties
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    var selectedTab: TabModel = .users
    var viewState: ViewState = .result
    
    // MARK: Initialization
    init() {
        observeNetwork()
    }

    //MARK: Private methods
    private func observeNetwork() {
        guard let monitor = networkMonitor as? NetworkMonitorImpl else { return }
        
        monitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.viewState = status ? .result : .noConnection
            }
            .store(in: &cancellables)
    }
}
