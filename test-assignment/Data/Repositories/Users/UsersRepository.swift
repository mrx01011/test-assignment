//
//  UsersRepository.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

protocol UsersRepository {
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponseDTO
    func fetchPositions() async throws -> [Position]
    func createUser(_ user: UserDTO) async throws -> CreateUserResponseDTO
}

final class UsersRepositoryImpl: UsersRepository {
    
    @Dependency(\.networkManager) private var networkManager
    @Dependency(\.authRepository) private var authRepository
    
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponseDTO {
        let endpoint = UsersEndpoint.getUsers(page: page, count: count)
        
        return try await networkManager.fetch(from: endpoint)
    }
    
    func fetchPositions() async throws -> [Position] {
        let endpoint = UsersEndpoint.getPositions
        let dto = try await networkManager.fetch(from: endpoint) as PositionsResponseDTO
        return dto.positions.map { $0.toDomain() }
    }
    
    func createUser(_ user: UserDTO) async throws -> CreateUserResponseDTO {
        let token = try await authRepository.getToken()
        let endpoint = UsersEndpoint.postUser
        
        return try await networkManager.uploadMultipart(
            to: endpoint,
            token: token
        ) { form in
            form.appendField(name: "name", value: user.name)
            form.appendField(name: "email", value: user.email)
            form.appendField(name: "phone", value: user.phone)
            form.appendField(name: "position_id", value: "\(user.position_id)")
            if let data = Data(base64Encoded: user.photo) {
              form.appendFile(
                name: "photo",
                fileName: "photo.jpg",
                mimeType: "image/jpeg",
                fileData: data
              )
            }
        }
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
