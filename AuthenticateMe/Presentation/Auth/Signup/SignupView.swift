//
//  SignupView.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - SignupView

struct SignupView: View {
    @ObservedObject var viewModel: SignupViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let banner = viewModel.bannerMessage {
                    ErrorBannerView(
                        message: banner,
                        accessibilityIdentifier: AccessibilityID.Signup.errorBanner,
                        onDismiss: { viewModel.bannerMessage = nil }
                    )
                }

                AppTextField(
                    title: String(localized: "auth.signup.firstName", bundle: .main),
                    placeholder: String(localized: "auth.signup.firstNamePlaceholder", bundle: .main),
                    text: firstNameBinding,
                    errorMessage: viewModel.firstNameError,
                    textContentType: .givenName,
                    accessibilityIdentifier: AccessibilityID.Signup.firstNameField
                )

                AppTextField(
                    title: String(localized: "auth.signup.lastName", bundle: .main),
                    placeholder: String(localized: "auth.signup.lastNamePlaceholder", bundle: .main),
                    text: lastNameBinding,
                    errorMessage: viewModel.lastNameError,
                    textContentType: .familyName,
                    accessibilityIdentifier: AccessibilityID.Signup.lastNameField
                )

                AppTextField(
                    title: String(localized: "auth.signup.email", bundle: .main),
                    placeholder: String(localized: "auth.signup.emailPlaceholder", bundle: .main),
                    text: emailBinding,
                    errorMessage: viewModel.emailError,
                    textContentType: .emailAddress,
                    keyboardType: .emailAddress,
                    accessibilityIdentifier: AccessibilityID.Signup.emailField
                )

                SecureAppTextField(
                    title: String(localized: "auth.signup.password", bundle: .main),
                    placeholder: String(localized: "auth.signup.passwordPlaceholder", bundle: .main),
                    text: passwordBinding,
                    errorMessage: viewModel.passwordError,
                    textContentType: .newPassword,
                    accessibilityIdentifier: AccessibilityID.Signup.passwordField
                )

                SecureAppTextField(
                    title: String(localized: "auth.signup.confirmPassword", bundle: .main),
                    placeholder: String(localized: "auth.signup.confirmPasswordPlaceholder", bundle: .main),
                    text: confirmPasswordBinding,
                    errorMessage: viewModel.confirmPasswordError,
                    textContentType: .newPassword,
                    accessibilityIdentifier: AccessibilityID.Signup.confirmPasswordField
                )

                LoadingButton(
                    title: String(localized: "auth.signup.submit", bundle: .main),
                    isLoading: viewModel.isLoading,
                    isEnabled: viewModel.isSubmitEnabled,
                    accessibilityIdentifier: AccessibilityID.Signup.createAccountButton,
                    action: { await viewModel.submit() }
                )

                Button(action: viewModel.navigateBackToLogin) {
                    Text(String(localized: "auth.signup.backToLogin", bundle: .main))
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .accessibilityIdentifier(AccessibilityID.Signup.backToLoginLink)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle(String(localized: "auth.signup.title", bundle: .main))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var firstNameBinding: Binding<String> {
        Binding(
            get: { viewModel.firstName },
            set: { viewModel.onFirstNameChanged($0) }
        )
    }

    private var lastNameBinding: Binding<String> {
        Binding(
            get: { viewModel.lastName },
            set: { viewModel.onLastNameChanged($0) }
        )
    }

    private var emailBinding: Binding<String> {
        Binding(
            get: { viewModel.email },
            set: { viewModel.onEmailChanged($0) }
        )
    }

    private var passwordBinding: Binding<String> {
        Binding(
            get: { viewModel.password },
            set: { viewModel.onPasswordChanged($0) }
        )
    }

    private var confirmPasswordBinding: Binding<String> {
        Binding(
            get: { viewModel.confirmPassword },
            set: { viewModel.onConfirmPasswordChanged($0) }
        )
    }
}
