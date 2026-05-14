//
//  HomeView.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    let user: User
    let onSignOut: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 52))
                .foregroundStyle(.green, .secondary)
                .accessibilityHidden(true)

            Text(String(localized: "home.title", bundle: .main))
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)
                .accessibilityIdentifier(AccessibilityID.Home.title)

            VStack(spacing: 6) {
                Text(
                    String(
                        format: String(localized: "home.nameFormat", bundle: .main),
                        user.firstName,
                        user.lastName
                    )
                )
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)

                Text(user.email)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .accessibilityIdentifier(AccessibilityID.Home.subtitle)

            Button(role: .none, action: onSignOut) {
                Text(String(localized: "home.signOut", bundle: .main))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 12)
            .accessibilityIdentifier(AccessibilityID.Home.signOutButton)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
