//
//  Fonts.swift
//  test-assignment
//
//  Created by Vlad on 10.06.2025.
//

import SwiftUICore

extension Font {
    private static let customFontStyleRegular: String = "NunitoSans-Regular"
    private static let customFontStyleSemibold: String = "NunitoSans-SemiBold"
    
    static var heading: Font {
        return .custom(customFontStyleRegular, size: 20)
    }
    
    static var body1: Font {
        return .custom(customFontStyleRegular, size: 16)
    }
    
    static var body2: Font {
        return .custom(customFontStyleRegular, size: 18)
    }
    
    static var body3: Font {
        return .custom(customFontStyleRegular, size: 14)
    }
    
    static var secondaryButton: Font {
        return .custom(customFontStyleSemibold, size: 16)
    }
    
    static var primaryButton: Font {
        return .custom(customFontStyleSemibold, size: 18)
    }
}
