//
//  PositionDTO.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import Foundation

struct PositionsResponseDTO: Decodable {
    let success: Bool
    let positions: [PositionDTO]
}

struct PositionDTO: Decodable {
    let id: Int
    let name: String
}

extension PositionDTO {
    func toDomain() -> Position {
        Position(id: id, name: name)
    }
}
