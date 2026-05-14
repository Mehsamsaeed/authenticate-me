# AuthenticateMe

SwiftUI iOS sample app for **email and password authentication**: sign in, create an account, and land on a simple signed-in home screen. Networking is simulated with a **mock API** so the project runs without a backend.

## Features

- **Login** and **signup** flows with client-side validation (email format, names, password rules, confirm password).
- **Coordinator-based navigation** between login and signup (`NavigationStack` + `navigationDestination`).
- **Session state** at the app root: unauthenticated users see auth; after success, **Home** with sign out.
- **Localized** copy via **String Catalog** (`Localizable.xcstrings`).
- **Accessibility identifiers** for UI testing (`AccessibilityID`).

## Requirements

- **Xcode** (project last updated with Xcode 26.x toolchain).
- **iOS 16.0** or later (simulator or device).
- Swift 5 / Swift concurrency settings as configured in the Xcode project.

## Getting started

1. Open `AuthenticateMe.xcodeproj` in Xcode.
2. Select the **AuthenticateMe** scheme and an iPhone simulator (or device).
3. Run (**⌘R**). The app uses `CompositionRoot.makeAppCoordinator()` from `AppRootView` to wire dependencies.

No API keys or server configuration are required; auth is handled by `MockAuthAPIService` behind `AuthenticationRepository`.

## Architecture

The app is organized in layers:

| Layer | Role |
|--------|------|
| **App** | `AuthenticateMeApp`, `AppRootView`, `CompositionRoot`, `AppDependencies` |
| **Domain** | Entities (`User`, `AuthError`), repository protocol, use cases (login/signup, validators) |
| **Data** | DTOs, `AuthenticationRepository`, mock API service and simulation config |
| **Presentation** | SwiftUI views and view models, reusable components, coordinators |
| **Core** | Shared helpers such as `AccessibilityID`, `UITestEnvironmentKey` |

Dependency flow: views and view models depend on **use cases**; use cases depend on **repository protocols**; the repository talks to the **mock API** implementation.

## Testing

- **Unit tests** (`AuthenticateMeTests`): use cases, repository behavior, view models, with `TestNetworkConfiguration` to control mock latency and failures.
- **UI tests** (`AuthenticateMeUITests`): drive the app via accessibility identifiers. Launch environment includes `UITEST_FAST_DELAY` and `UITEST_PLAIN_TEXT_PASSWORDS` (plain text password fields during UI tests only, for reliable typing).

Run tests with **⌘U** or the **AuthenticateMe** shared scheme test action.

## Repository layout

```
AuthenticateMe/           # App sources (SwiftUI, domain, data, presentation)
AuthenticateMeTests/      # Unit tests
AuthenticateMeUITests/    # UI tests
AuthenticateMe.xctestplan # Shared test plan (parallelization / targets)
```

## License

No license file is included in this repository. Add one (for example MIT) if you plan to publish the project publicly.
