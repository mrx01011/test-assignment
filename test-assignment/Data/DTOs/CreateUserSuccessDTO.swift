//
//  CreateUserSuccessDTO.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import Foundation

struct CreateUserResponseDTO: Decodable {
    let success: Bool
    let user_id: Int
    let message: String
}
