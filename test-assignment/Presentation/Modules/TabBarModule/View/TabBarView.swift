//
//  TabBar.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI

struct TabBarView: View {
    // MARK: ViewModel
    @State private var viewModel = TabBarViewModel()
    
    // MARK: Properties
    @State private var tabBarSize: CGSize?
    
    // MARK: Body
    var body: some View {
        switch viewModel.viewState {
        case .skeletonable, .result, .emptyList:
            ZStack(alignment: .bottom) {
                FakeTabBar() // Fake native tab bar
                
                CustomTabBar() // Сustom-designed tab bar that follows the app's Figma design
            }
        case .noConnection:
            NoConnectionView()
        }
    }
}

// MARK: - Views
extension TabBarView {
    @ViewBuilder
    func FakeTabBar() -> some View {
        TabView(selection: $viewModel.selectedTab) {
            Tab.init(value: .users) {
                UsersView()
                    .safeAreaPadding(.bottom, tabBarSize?.height)
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: .signUp) {
                Text("Sign Up")
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        GeometryReader {
            let size = $0.size
            HStack(spacing: 0) {
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    HStack(spacing: 8) {
                        Image(systemName: tab.rawValue)
                        
                        Text(tab.title)
                            .lineLimit(1)
                    }
                    .font(Font.secondaryButton)
                    .foregroundStyle(viewModel.selectedTab == tab ? .appSecondary : .black.opacity(0.6))
                    .frame(width: size.width / CGFloat(TabModel.allCases.count))
                    .contentShape(.rect)
                    .onTapGesture {
                        viewModel.selectedTab = tab
                    }
                }
            }
            .padding(.vertical, 16)
            .background(Color.tabBarBackground)
            .onAppear {
                tabBarSize = size
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
    
    @ViewBuilder
    func NoConnectionView() -> some View {
        VStack(spacing: 24) {
            Image(.noConnectionImg)

            Text("There is no internet connection")
                .font(.heading)
                .foregroundStyle(.black.opacity(0.87))

            Button {
                 // Trigger the retry action
            } label: {
                Text("Try again")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    TabBarView()
}

