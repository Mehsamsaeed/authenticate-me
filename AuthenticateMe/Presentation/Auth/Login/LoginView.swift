//
//  LoginView.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - LoginView

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                if let banner = viewModel.bannerMessage {
                    ErrorBannerView(
                        message: banner,
                        accessibilityIdentifier: AccessibilityID.Login.errorBanner,
                        onDismiss: { viewModel.bannerMessage = nil }
                    )
                }

                AppTextField(
                    title: String(localized: "auth.login.emailLabel", bundle: .main),
                    placeholder: String(localized: "auth.login.emailPlaceholder", bundle: .main),
                    text: emailBinding,
                    errorMessage: viewModel.emailError,
                    textContentType: .username,
                    keyboardType: .emailAddress,
                    accessibilityIdentifier: AccessibilityID.Login.emailField
                )

                SecureAppTextField(
                    title: String(localized: "auth.login.passwordLabel", bundle: .main),
                    placeholder: String(localized: "auth.login.passwordPlaceholder", bundle: .main),
                    text: passwordBinding,
                    errorMessage: viewModel.passwordError,
                    textContentType: .password,
                    accessibilityIdentifier: AccessibilityID.Login.passwordField
                )

                LoadingButton(
                    title: String(localized: "auth.login.submit", bundle: .main),
                    isLoading: viewModel.isLoading,
                    isEnabled: viewModel.isSubmitEnabled,
                    accessibilityIdentifier: AccessibilityID.Login.loginButton,
                    action: { await viewModel.submit() }
                )

                Button(action: viewModel.presentForgotPassword) {
                    Text(String(localized: "auth.login.forgotPassword", bundle: .main))
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .accessibilityIdentifier(AccessibilityID.Login.forgotPasswordButton)

                signupFooter
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .navigationTitle(String(localized: "auth.login.title", bundle: .main))
        .navigationBarTitleDisplayMode(.large)
        .alert(
            String(localized: "auth.forgotPassword.title", bundle: .main),
            isPresented: $viewModel.isForgotPasswordAlertPresented
        ) {
            Button(String(localized: "auth.alert.ok", bundle: .main), role: .cancel) {}
        } message: {
            Text(String(localized: "auth.forgotPassword.message", bundle: .main))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "auth.login.subtitle", bundle: .main))
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var signupFooter: some View {
        HStack(spacing: 6) {
            Text(String(localized: "auth.login.footer", bundle: .main))
                .foregroundStyle(.secondary)
            Button(action: viewModel.navigateToSignup) {
                Text(String(localized: "auth.login.signupAction", bundle: .main))
                    .fontWeight(.semibold)
            }
            .accessibilityIdentifier(AccessibilityID.Login.goToSignupLink)
        }
        .font(.footnote)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 8)
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
}
