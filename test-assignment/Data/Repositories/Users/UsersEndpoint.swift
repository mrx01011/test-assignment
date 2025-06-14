//
//  UsersRequest.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

enum UsersEndpoint: Endpoint {
    case getUsers(page: Int, count: Int)
    case getPositions
    case postUser
    
    var path: String {
        switch self {
        case .getUsers, .postUser:
            return "/users"
        case .getPositions:
            return "/positions"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getUsers, .getPositions:
            return .get
        case .postUser:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .getUsers(page, count):
            return [
                "page": page,
                "count": count
            ]
        case .getPositions, .postUser:
            return nil
        }
    }
}
