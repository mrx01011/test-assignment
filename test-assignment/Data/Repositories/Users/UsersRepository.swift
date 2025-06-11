//
//  UsersRepository.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

protocol UsersRepository {
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponseDTO
}

final class UsersRepositoryImpl: UsersRepository {
    
    @Dependency(\.networkManager) private var networkManager
    
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponseDTO {
        let endpoint = UsersEndpoint.getUsers(page: page, count: count)
        
        return try await networkManager.fetch(from: endpoint)
    }
}

private struct UsersRepositoryKey: DependencyKey {
    static var currentValue: UsersRepository = UsersRepositoryImpl()
}

extension DependencyValues {
    var usersRepository: UsersRepository {
        get { Self[UsersRepositoryKey.self] }
        set { Self[UsersRepositoryKey.self] = newValue }
    }
}
