//
//  SignUpResultView.swift
//  test-assignment
//
//  Created by Vlad on 13.06.2025.
//

import SwiftUI

struct SignUpResultView: View {
    enum ViewType {
        case success
        case error
    }
    
    var text: String
    var type: ViewType
    var onCloseAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button(action: onCloseAction) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black.opacity(0.48))
                }
                .frame(width: 24, height: 24)
            }
            .padding(.all, 24)
            
            Spacer()
            
            Image(type == .success ? .serverSuccessImg : .serverErrorImg)
            
            Text(text)
                .font(.heading)
                .foregroundStyle(.black.opacity(0.87))
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            Button {
                onCloseAction()
            } label: {
                Text(type == .success ? "Got it" : "Try again")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 24)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    SignUpResultView(text: "Error", type: .success, onCloseAction: {
        
    })
}
