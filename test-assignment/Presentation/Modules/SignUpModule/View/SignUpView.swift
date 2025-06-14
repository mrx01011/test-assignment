//
//  SignUpView.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct SignUpView: View {
    // MARK: ViewModel
    @Dependency(\.signUpViewModel)
    var viewModel: SignUpViewModel
    
    // MARK: Routing items
    @State private var isChoosePhotoDidTapped: Bool = false
    @State private var isGalleryDidTapped: Bool = false
    @State private var isCameraDidTapped: Bool = false
    
    // MARK: Properties
    // Name TextField
    @State private var nameText: String = ""
    @FocusState private var isNameTFFocused: Bool
    // Email TextField
    @State private var emailText: String = ""
    @FocusState private var isEmailTFFocused: Bool
    // Phone TextField
    @State private var phoneText: String = ""
    @FocusState private var isPhoneTFFocused: Bool
    // Image Picker
    @State private var selectedPhoto: PhotosPickerItem?
    
    // MARK: Body
    var body: some View {
        switch viewModel.props {
        case .initial:
            ScrollView {
                MainContent()
            }
            .onTapGesture {
                isNameTFFocused = false
                isEmailTFFocused = false
                isPhoneTFFocused = false
            }
            .background(Color.background)
            .ignoresSafeArea(.keyboard)
        case .success(let text):
            SignUpResultView(text: text, type: .success) {
                viewModel.props = .initial
                viewModel.clearForms()
                emailText.removeAll()
                phoneText.removeAll()
                nameText.removeAll()
            }
        case .error(let text):
            SignUpResultView(text: text, type: .error) {
                viewModel.props = .initial
            }
        }
    }
}
// MARK: - Views
private extension SignUpView {
    @ViewBuilder
    func MainContent() -> some View {
        VStack(spacing: 0) {
            TopBarView(title: "Working with POST request")
            
            TextFieldsStack()
                .padding(.horizontal, 16)
                .padding(.top, 32)
            
            PositionPicker()
                .padding(.horizontal, 16)
                .padding(.top, 24)
            
            ImagePicker()
                .padding(.horizontal, 16)
                .padding(.top, 24)
            
            SignUpButton()
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
        }
        .padding(.top, 1)
        .frame(maxWidth: .infinity)
        .onChange(of: nameText) { oldValue, newValue in
            viewModel.nameText = newValue
        }
        .onChange(of: emailText) { oldValue, newValue in
            viewModel.emailText = newValue
        }
        .onChange(of: phoneText) { oldValue, newValue in
            viewModel.phoneText = newValue
        }
    }
    
    @ViewBuilder
    func TextFieldsStack() -> some View {
        VStack(spacing: 12) {
            LabeledTextField(label: viewModel.nameTextFieldLabel,
                             supportingText: "",
                             state: viewModel.nameTextFieldState,
                             errorText: viewModel.nameTextFieldError,
                             text: $nameText)
            .focused($isNameTFFocused)
            .onChange(of: isNameTFFocused) { oldValue, newValue in
                viewModel.nameTextFieldState = newValue ? .focused : .normal
            }
            
            LabeledTextField(label: viewModel.emailTextFieldLabel,
                             supportingText: "",
                             state: viewModel.emailTextFieldState,
                             errorText: viewModel.emailTextFieldError,
                             text: $emailText)
            .focused($isEmailTFFocused)
            .onChange(of: isEmailTFFocused) { oldValue, newValue in
                viewModel.emailTextFieldState = newValue ? .focused : .normal
            }
            
            LabeledTextField(label: viewModel.phoneTextFieldLabel,
                             supportingText: viewModel.phoneTextFieldSupportingText,
                             state: viewModel.phoneTextFieldState,
                             errorText: viewModel.phoneTextFieldError,
                             text: $phoneText)
            .focused($isPhoneTFFocused)
            .onChange(of: isPhoneTFFocused) { oldValue, newValue in
                viewModel.phoneTextFieldState = newValue ? .focused : .normal
            }
        }
    }
    
    @ViewBuilder
    func PositionPicker() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select your position")
                .font(.body2)
                .foregroundStyle(.black.opacity(0.87))
            
            ForEach(viewModel.positions) { position in
                HStack(spacing: 24) {
                    CustomPickerButton(isSelected: viewModel.selectedPosition?.id == position.id)
                    
                    Text(position.name)
                        .font(.body1)
                        .foregroundStyle(.black.opacity(0.87))
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(.rect)
                .onTapGesture {
                    viewModel.selectedPosition = position
                }
            }
        }
    }
    
    @ViewBuilder
    func ImagePicker() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(viewModel.selectedPhotoData == nil ? "Upload your photo" : "Photo selected")
                    .font(.body2)
                    .foregroundStyle(.black.opacity(0.48))
                
                Spacer()
                
                Text("Upload")
                    .font(.body2)
                    .foregroundStyle(.appSecondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.textFieldNormalBorder, lineWidth: 1)
            )
            
            Text("Photo is required")
                .font(.body3)
                .foregroundStyle(Color.textFieldErrorBorder)
                .padding(.horizontal, 16)
                .opacity(0)
        }
        .contentShape(.rect)
        .onTapGesture {
            isChoosePhotoDidTapped.toggle()
        }
        .confirmationDialog("Choose how you want to add a photo", isPresented: $isChoosePhotoDidTapped) {
            Button("Camera") {
                isCameraDidTapped.toggle()
            }
            
            Button("Gallery") {
                isGalleryDidTapped.toggle()
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Choose how you want to add a photo")
        }
        .photosPicker(isPresented: $isGalleryDidTapped, selection: $selectedPhoto, matching: .images)
        .fullScreenCover(isPresented: $isCameraDidTapped) {
            CameraView { image in
                viewModel.handlePickedImage(image)
            }
        }
        .onChange(of: selectedPhoto) {
            Task {
                if let selectedPhoto = selectedPhoto,
                   let data = try? await selectedPhoto.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.handlePickedImage(image)
                }
            }
        }
    }
    
    @ViewBuilder
    func SignUpButton() -> some View {
        Button {
            Task {
                await viewModel.signUp()
            }
        } label: {
            Text("Sign up")
        }
        .disabled(viewModel.isSignUpButtonDisabled())
        .buttonStyle(PrimaryButtonStyle())

    }
}

#Preview {
    TabBarView()
}
