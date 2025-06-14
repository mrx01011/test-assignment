//
//  UsersView.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct UsersView: View {
    
    @Dependency(\.usersViewModel)
    var viewModel: UsersViewModel
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Working with GET request")
            switch viewModel.viewState {
            case .result, .noConnection:
                UsersList()
            case .emptyList:
                EmptyList()
            }
        }
        .padding(.top, 1)
        .frame(maxWidth: .infinity)
        .background(Color.background)
    }
}
// MARK: - Views
private extension UsersView {
    @ViewBuilder
    func UsersList() -> some View {
        List(viewModel.users) { user in
            UserCell(with: user)
                .listRowBackground(Color.background)
                .listRowSpacing(0)
                .onAppear {
                    if viewModel.users.last?.id == user.id {
                        Task { await viewModel.loadNextPage() }
                    }
                }
            
            if viewModel.users.last?.id == user.id &&
                viewModel.isLoading {
                HStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primaryButtonDisabledBackground)
                        .controlSize(.large)
                    
                    Spacer()
                }
                .padding(.bottom, 24)
                .listRowBackground(Color.background)
                .listRowSpacing(0)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.never)
        .padding(.horizontal, 16)
        .refreshable {
            Task {
                /// Workaround: Without a small delay, the .refreshable animation may cause the List to "jump"
                /// This happens because the refresh completes too quickly for SwiftUI to finalize the transition smoothly
                /// A short artificial delay gives the UI enough time to settle.
                try? await Task.sleep(nanoseconds: 500_000_000)
                await viewModel.loadFirstPage()
            }
        }
    }
    
    @ViewBuilder
    func EmptyList() -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(.homeEmptyListimg)
            
            Text("There are no users yet")
                .font(.heading)
                .foregroundStyle(Color.black.opacity(0.87))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func UserCell(with user: User) -> some View {
        HStack(alignment: .top, spacing: 16) {
            WebImage(url: user.photo)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(user.name)
                    .font(.body2)
                    .foregroundStyle(.black.opacity(0.87))
                
                Text(user.position)
                    .font(.body3)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.top, 4)
                
                Text(user.email)
                    .font(.body3)
                    .foregroundStyle(.black.opacity(0.87))
                    .lineLimit(1)
                    .padding(.top, 8)
                
                Text(user.phone)
                    .font(.body3)
                    .foregroundStyle(.black.opacity(0.87))
                    .lineLimit(1)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 24)
    }
}


#Preview {
    TabBarView()
}
