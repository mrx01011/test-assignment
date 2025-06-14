//
//  LabeledTextField.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import SwiftUI

enum TextFieldState {
    case normal
    case focused
    case error
}

struct LabeledTextField: View {
    let label: String
    let supportingText: String
    var state: TextFieldState
    var errorText: String
    
    @Binding var text: String

    private var borderColor: Color {
        switch state {
        case .normal:
            return Color.textFieldNormalBorder
        case .focused:
            return Color.appSecondary
        case .error:
            return Color.textFieldErrorBorder
        }
    }
    
    private var labelTextColor: Color {
        switch state {
        case .normal:
            return .black.opacity(0.6)
        case .focused:
            return text.isEmpty ? .appSecondary : .black.opacity(0.6)
        case .error:
            return .textFieldErrorBorder
        }
    }

    private var supportingTextColor: Color {
        switch state {
        case .normal, .focused:
            return .black.opacity(0.6)
        case .error:
            return .textFieldErrorBorder
        }
    }
    
    private var placeholderColor: Color {
        switch state {
        case .normal:
            return text.isEmpty ? .black.opacity(0.6) : .black.opacity(0.87)
        case .focused:
            return text.isEmpty ? .white : .black.opacity(0.87)
        case .error:
            return text.isEmpty ? .textFieldErrorBorder : .black.opacity(0.87)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 0) {
                if state == .focused || !text.isEmpty {
                    Text(label)
                        .font(.body3)
                        .foregroundStyle(labelTextColor)
                }
                TextField("", text: $text,
                          prompt: Text(label)
                    .font(.body1)
                    .foregroundStyle(placeholderColor))
                .keyboardType(.alphabet)
                .font(.body1)
                .foregroundStyle(.black.opacity(0.87))
            }
            .padding(.vertical,(state == .focused || !text.isEmpty) ? 4 : 12)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(borderColor, lineWidth: 1)
            )
            
            Text(state == .error ? errorText : supportingText)
                .font(.body3)
                .foregroundColor(state == .error ? .textFieldErrorBorder : .black.opacity(0.6))
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    TabBarView()
}
