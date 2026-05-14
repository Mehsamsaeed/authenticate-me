//
//  LoadingButton.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - LoadingButton

/// Primary action button that reflects loading state and disables interaction while busy.
struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let accessibilityIdentifier: String
    let action: @MainActor () async -> Void

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            ZStack {
                Text(title)
                    .font(.headline)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isEnabled ? Color.accentColor : Color.accentColor.opacity(0.35))
            )
            .foregroundStyle(.white)
        }
        .disabled(!isEnabled || isLoading)
        .accessibilityIdentifier(accessibilityIdentifier)
        .accessibilityAddTraits(.isButton)
    }
}
