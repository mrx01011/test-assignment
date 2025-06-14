//
//  CustomPickerButton.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import SwiftUI

struct CustomPickerButton: View {
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.appSecondary : Color.background)
                .stroke(isSelected ? Color.appSecondary : Color.textFieldNormalBorder, lineWidth: 1)
                .frame(width: 14, height: 14)
            
            if isSelected {
                Circle()
                    .fill(Color.background)
                    .frame(width: 6, height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
