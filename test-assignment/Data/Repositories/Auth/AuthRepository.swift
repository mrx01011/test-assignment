//
//  UsersRepository.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

protocol AuthRepository {
    func getToken() async throws -> String
}

final class AuthRepositoryImpl: AuthRepository {
    
    @Dependency(\.networkManager) private var networkManager
    
    func getToken() async throws -> String {
        let endpoint = AuthEndpoint.getToken
        let result: TokenResponseDTO = try await networkManager.fetch(from: endpoint)
        return result.token
    }
}

private struct AuthRepositoryKey: DependencyKey {
    static var currentValue: AuthRepository = AuthRepositoryImpl()
}

extension DependencyValues {
    var authRepository: AuthRepository {
        get { Self[AuthRepositoryKey.self] }
        set { Self[AuthRepositoryKey.self] = newValue }
    }
}
