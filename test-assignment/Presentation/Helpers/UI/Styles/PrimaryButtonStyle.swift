//
//  PrimaryButtonStyle.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.primaryButton)
            .foregroundColor(isEnabled ? .black.opacity(0.87) : .black.opacity(0.47))
            .padding(.vertical, 12)
            .frame(width: 140)
            .background(
                Capsule()
                    .fill(backgroundColor(configuration: configuration))
            )
    }
    
    private func backgroundColor(configuration: Configuration) -> Color {
        if !isEnabled {
            return Color.primaryButtonDisabledBackground // Disabled
        } else if configuration.isPressed {
            return Color.primaryButtonPressedBackground // Pressed
        } else {
            return Color.appPrimary // Normal
        }
    }
}
