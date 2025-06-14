//
//  UserDTO.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let position_id: Int
    let registration_timestamp: Int
    let photo: String
}

struct UsersResponseDTO: Decodable {
    let success: Bool
    let page: Int
    let total_pages: Int
    let total_users: Int
    let count: Int
    let links: LinksDTO
    let users: [UserDTO]
}

struct LinksDTO: Decodable {
    let next_url: String?
    let prev_url: String?
}

extension UserDTO {
    func toDomain() -> User {
        User(
            id: id,
            name: name,
            email: email,
            phone: phone,
            position: position,
            photo: URL(string: photo)
        )
    }
}
