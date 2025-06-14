//
//  UsersViewModel.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI

@Observable
final class UsersViewModel {
    // MARK: Dependency
    @ObservationIgnored
    @Dependency(\.usersRepository)
    private var usersRepository: UsersRepository

    // MARK: Properties
    var viewState: ViewState = .emptyList
    
    var users: [User] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isLoading: Bool = false
    
    private let pageSize = 6
    
    // MARK: Initialization
    init() {
        Task {
            await loadFirstPage()
        }
    }
    
    // MARK: Internal methods
    @MainActor
    func loadFirstPage() async {
        currentPage = 1
        users.removeAll()
        await loadPage()
    }
    
    @MainActor
    func loadNextPage() async {
        guard currentPage < totalPages, !isLoading else { return }
        currentPage += 1
        await loadPage()
    }
    
    // MARK: Private methods
    @MainActor
    private func loadPage() async {
        isLoading = true
        do {
            let response = try await usersRepository.fetchUsers(page: currentPage, count: pageSize)
            totalPages = response.total_pages
            let newUsers = response.users.map { $0.toDomain() }
            users.append(contentsOf: newUsers)
        } catch {
            if users.isEmpty {
                viewState = .emptyList
            }
            print("Failed to fetch users page \(currentPage):", error)
        }
        isLoading = false
        viewState = .result
    }
}

// MARK: - DI KEY
struct UsersViewModelKey: DependencyKey {
    static var currentValue: UsersViewModel = UsersViewModel()
}

extension DependencyValues {
    var usersViewModel: UsersViewModel {
        get { Self[UsersViewModelKey.self] }
        set { Self[UsersViewModelKey.self] = newValue }
    }
}
