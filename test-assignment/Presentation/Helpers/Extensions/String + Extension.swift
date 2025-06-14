//
//  String + Extension.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import Foundation
// MARK: Text validation
extension String {
    // Validate name: 2-60 characters
    func isNameValid() -> Bool {
        if !isEmpty,
           trimmingCharacters(in: .whitespacesAndNewlines).count >= 2,
           trimmingCharacters(in: .whitespacesAndNewlines).count <= 60 {
            return true
        }
        return false
    }
    
    // Validate email with RFC-compatible regex
    func isEmailValid() -> Bool {
        let emailPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: self) 
    }
    
    // Validate phone: must start with "+380"
    func isPhoneNumberValid() -> Bool {
        let cleanedNumber = self.replacingOccurrences(of: "[^+0-9]", with: "", options: .regularExpression)
        return cleanedNumber.hasPrefix("+380")
    }
}
