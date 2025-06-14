//
//  SignUpViewModel.swift
//  test-assignment
//
//  Created by Vlad on 12.06.2025.
//

import SwiftUI

@Observable
final class SignUpViewModel {
    // MARK: Dependency
    @ObservationIgnored
    @Dependency(\.usersRepository)
    private var usersRepository: UsersRepository

    // MARK: Properties
    var props: Props = .initial
    var positions: [Position] = []
    var selectedPosition: Position?
    
    // Name TextField
    @ObservationIgnored
    var nameText: String = ""
    var nameTextFieldState: TextFieldState = .normal
    var nameTextFieldError: String = "Required field"
    let nameTextFieldLabel: String = "Your name"
    // Email TextField
    @ObservationIgnored
    var emailText: String = ""
    var emailTextFieldState: TextFieldState = .normal
    var emailTextFieldError: String = "Invalid email format"
    let emailTextFieldLabel: String = "Email"
    // Phone TextField
    @ObservationIgnored
    var phoneText: String = ""
    var phoneTextFieldState: TextFieldState = .normal
    var phoneTextFieldError: String = "Required field"
    let phoneTextFieldLabel: String = "Phone"
    let phoneTextFieldSupportingText: String = "+38 (XXX) XXX - XX - XX"
    // ImagePicker
    var selectedPhotoData: Data? = nil
    
    // MARK: Initialization
    init() {
        Task {
            await loadPositions()
        }
    }
    
    // MARK: Internal methods
    @MainActor
    func handlePickedImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { return }
        selectedPhotoData = data
    }
    
    func isSignUpButtonDisabled() -> Bool {
        return !(!nameText.isEmpty &&
                 !emailText.isEmpty &&
                 !phoneText.isEmpty &&
                 selectedPhotoData != nil)
    }
    
    @MainActor
    func clearForms() {
        nameText.removeAll()
        nameTextFieldState = .normal
        emailText.removeAll()
        emailTextFieldState = .normal
        phoneText.removeAll()
        phoneTextFieldState = .normal
        selectedPhotoData = nil
    }
    
    @MainActor
    func signUp() async {
        guard validateForm(),
              let selectedPosition,
              let selectedPhotoData else {
            return
        }

        let userDTO = UserDTO(id: -99,
                              name: nameText,
                              email: emailText,
                              phone: phoneText,
                              position: selectedPosition.name,
                              position_id: selectedPosition.id,
                              registration_timestamp: -99,
                              photo: selectedPhotoData.base64EncodedString())
        
        do {
            let response = try await usersRepository.createUser(userDTO)
            props = .success(text: response.message)
        } catch let error as NetworkError {
            switch error {
            case .clientError(let code):
                switch code {
                case 401:
                    props = .error(text: "The token expired.")
                case 409:
                    props = .error(text: "User with this phone or email already exist")
                case 422:
                    props = .error(text: "Validation failed")
                default:
                    break
                }
            default:
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: Private Methods
    @MainActor
    private func loadPositions() async {
        do {
            positions = try await usersRepository.fetchPositions()
            selectedPosition = positions.first
        } catch {
            print("Failed to fetch positions: \(error)")
        }
    }
    
    private func validateForm() -> Bool {
        var hasError = false
        
        // Validate name
        if !nameText.isNameValid() {
            nameTextFieldError = "Name must be between 2 and 60 characters"
            nameTextFieldState = .error
            hasError = true
        }
        
        // Validate email
        if !emailText.isEmailValid() {
            emailTextFieldError = "Invalid email format"
            emailTextFieldState = .error
            hasError = true
        }
        
        // Validate phone
        if !phoneText.isPhoneNumberValid() {
            phoneTextFieldState = .error
            phoneTextFieldError = "Invalid phone format"
            hasError = true
        }
        
        // Validate position, photo selected
        if selectedPosition == nil,
           selectedPhotoData == nil {
            hasError = true
        }
        
        if hasError {
            return false
        }
        return true
    }
    
}
// MARK: Props
extension SignUpViewModel {
    enum Props {
        case initial
        case success(text: String)
        case error(text: String)
    }
}

// MARK: - DI KEY
struct SignUpViewModelKey: DependencyKey {
    static var currentValue: SignUpViewModel = SignUpViewModel()
}

extension DependencyValues {
    var signUpViewModel: SignUpViewModel {
        get { Self[SignUpViewModelKey.self] }
        set { Self[SignUpViewModelKey.self] = newValue }
    }
}
