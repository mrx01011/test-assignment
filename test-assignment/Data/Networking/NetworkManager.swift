//
//  NetworkManaging.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

protocol NetworkManager {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class NetworkManagerImpl: NetworkManager {
    static let shared = NetworkManagerImpl()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()
        #if DEBUG
        print(request)
        #endif
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateResponse(httpResponse)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400...499:
            throw NetworkError.clientError(response.statusCode)
        case 500...599:
            throw NetworkError.serverError(response.statusCode)
        default:
            throw NetworkError.unknownError(response.statusCode)
        }
    }
}

private struct NetworkManagerKey: DependencyKey {
    static var currentValue: NetworkManager = NetworkManagerImpl.shared
}

extension DependencyValues {
    var networkManager: NetworkManager {
        get { Self[NetworkManagerKey.self] }
        set { Self[NetworkManagerKey.self] = newValue }
    }
}
