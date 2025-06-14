//
//  TokenResponseDTO.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import Foundation

struct TokenResponseDTO: Decodable {
    let success: Bool
    let token: String
}
