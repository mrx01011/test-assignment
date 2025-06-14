//
//  TopBarView.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI

struct TopBarView: View {
    
    private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.heading)
                .foregroundStyle(.topBarTitle)
                .padding(.all, 16)
                .frame(maxWidth: .infinity)
                .background(Color.appPrimary)
        }
    }
}
