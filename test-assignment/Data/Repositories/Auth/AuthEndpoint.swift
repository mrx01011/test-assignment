//
//  UsersRequest.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

enum AuthEndpoint: Endpoint {
    case getToken
    
    var path: String {
        switch self {
        case .getToken:
            return "/token"
        }
    }
}
