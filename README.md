# Test assignment

This README documents the project structure, configuration, and usage.

---

## Table of Contents

1. [Services](#services)
2. [Data Transfer Objects (DTOs)](#data-transfer-objects-dtos)
3. [Networking Layer](#networking-layer)
4. [Repositories & Data Layer](#repositories--data-layer)
5. [Dependency Injection (DI)](#dependency-injection-di)
6. [Resources & Assets](#resources--assets)
7. [Info.plist Configuration](#infoplist-configuration)
8. [Modules & Main App](#modules--main-app)
9. [Helpers](#helpers)
10. [Build Instructions](#build-instructions)

---

## Services

### NetworkMonitor

* **Purpose**: Publishes network connectivity status for the app.
* **Location**: `Services/NetworkMonitor.swift`
* **Key features**:

  * Uses `NWPathMonitor` internally.
  * Publishes `@Published var isConnected: Bool` via `ObservableObject`.

```swift
final class NetworkMonitor: ObservableObject { ... }
```

---

## Data Transfer Objects (DTOs)

All DTOs live under `Data/DTOs/`.

* **TokenResponseDTO**: Maps authentication token response.
* **CreateUserSuccessDTO**: Models the 201 response containing `user_id` and message.
* **ErrorResponseDTO**: Handles API error bodies for status 401, 409, 422.
* **PositionDTO & UsersResponseDTO**: Represents positions and paginated users.
* **UserDTO**: Payload for creating a new user, including photo binary.

```swift
struct TokenResponseDTO: Decodable { ... }
```

---

## Networking Layer

* **Endpoint Protocol** (`Networking/Endpoint.swift`): Defines `baseURL`, `path`, `method`, `headers`, `parameters`, and `urlRequest()`.
* **HTTPMethod** (`Networking/HTTPMethod.swift`): Enum of HTTP verbs.
* **NetworkManager** (`Networking/NetworkManager.swift`): Protocol `fetch<T: Decodable>` and `uploadMultipart`, implemented by `NetworkManagerImpl` using `URLSession` and `validateResponse`.
* **MultipartFormData** (`Networking/MultipartFormData.swift`): Helper for building multipart bodies.
* **NetworkError** (`Networking/NetworkError.swift`): Defines client/server/decoding errors.

---

## Repositories & Data Layer

All repository files under `Repositories/`.

### UsersRepository

* **File**: `UsersRepository.swift`
* Methods:

  * `fetchUsers(page: Int, count: Int) -> UsersResponseDTO`
  * `fetchPositions() -> [Position]`
  * `createUser(_: UserDTO) -> Int` (returns `user_id`)

### AuthRepository

* **File**: `AuthRepository.swift`
* Methods:

  * `getToken() -> String`

### Endpoints

* **Files**: `Networking/UsersEndpoint.swift`, `Networking/AuthEndpoint.swift`.

---

## Dependency Injection (DI)

* **Dependency Container** (`DI/Dependency.swift`): Registers and resolves dependencies using factory closures.
* **Usage**:

  ```swift
  container.register(NetworkManager.self) { NetworkManagerImpl.shared }
  container.register(UsersRepository.self) { UsersRepositoryImpl() }
  container.register(AuthRepository.self) { AuthRepositoryImpl() }
  ```
* **Injection** in ViewModels:

  ```swift
  @Dependency(\.usersRepository) var repo: UsersRepository
  ```

---

## Resources & Assets

### Fonts

* **Nunito Sans** (`Resources/Fonts/NunitoSans-Regular.ttf`, `NunitoSans-SemiBold.ttf`)
* Register in `Info.plist` under `UIAppFonts`.

### Colors

* Defined in `Resources/Colors.xcassets`.

---

## Info.plist Configuration

* **Fonts** under `UIAppFonts`.
* **App Transport Security** (if HTTP):

  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key><true/>
  </dict>
  ```
* **Permissions** for camera/photo library:

  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Need camera to upload user photo.</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>Need library access to upload user photo.</string>
  ```

---

## Modules & Main App

### Modules

* **Services**, **Data**, **Networking**, **Repositories**, **DI**, **Views**, **ViewModels**, **Styles**, **Resources**.

### Domain Models

* `Models/User.swift`, `Models/Position.swift`

### Main Entry Point

* **MainApp** (`MainApp.swift`): Initializes DI, registers dependencies, and sets `TabBarView` as root.

```swift
@main
struct MainApp: App {
  let container = DependencyContainerImpl()
  init() { container.setupDependencies() }
  var body: some Scene {
    WindowGroup {
      TabBarView()
        .environmentObject(container.resolve(type: NetworkMonitor.self)!)
    }
  }
}
```

---

## Helpers

Utility views and extensions:

* **TopBarView**, **LabeledTextField**, **PrimaryButtonStyle**, **CustomPickerButton**, **CameraView**, **SignUpResultView**, **TabModel**.
* **String+Extensions**, **Data+Extensions** for `MultipartFormData`.

---

## External Libraries

- **SDWebImageSwiftUI**: Used for async image loading and caching in SwiftUI views. Provides `WebImage` view for efficient image display.
  - Add via Swift Package Manager: `https://github.com/SDWebImage/SDWebImageSwiftUI`


## Build Instructions

1. Clone repo: `git clone <repo-url>`
2. Open in Xcode: `YourApp.xcodeproj`
3. Select target (iOS 15.0+)
4. Run: `Cmd+R`
5. Configure DI in `App` initializer.

