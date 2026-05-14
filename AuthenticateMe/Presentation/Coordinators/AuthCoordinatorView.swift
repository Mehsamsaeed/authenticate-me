//
//  AuthCoordinatorView.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - AuthCoordinatorView

/// Hosts the auth navigation stack using the iOS 16 navigation destination API.
@MainActor
struct AuthCoordinatorView: View {
    @ObservedObject var coordinator: AuthCoordinator

    var body: some View {
        NavigationStack {
            LoginView(viewModel: coordinator.loginViewModel)
                .navigationDestination(isPresented: signupPresentedBinding) {
                    signupDestination
                }
        }
    }

    private var signupPresentedBinding: Binding<Bool> {
        Binding(
            get: { coordinator.isSignupPresented },
            set: { newValue in
                if !newValue {
                    coordinator.dismissSignup()
                }
            }
        )
    }

    @ViewBuilder
    private var signupDestination: some View {
        if let viewModel = coordinator.signupViewModel {
            SignupView(viewModel: viewModel)
        } else {
            Color.clear
                .frame(width: 1, height: 1)
        }
    }
}
