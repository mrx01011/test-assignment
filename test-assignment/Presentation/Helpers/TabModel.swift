//
//  TabModel.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

enum TabModel: String, CaseIterable {
    case users = "person.3.sequence.fill"
    case signUp = "person.crop.circle.fill.badge.plus"
    
    var title: String {
        switch self {
        case .users: "Users"
        case .signUp: "Sign Up"
        }
    }
}
