//
//  UsersRequest.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

enum UsersEndpoint: Endpoint {
    case getUsers(page: Int, count: Int)
//    case getUserById(Int)
//    case postUser
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .getUsers(page, count):
            return [
                "page": page,
                "count": count
            ]
        }
    }
}
