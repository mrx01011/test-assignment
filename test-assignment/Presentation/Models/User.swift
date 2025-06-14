//
//  User.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photo: URL?
}
