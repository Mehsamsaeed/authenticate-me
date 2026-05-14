//
//  ErrorBannerView.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - ErrorBannerView

/// Non-blocking banner for surfaced API or unexpected failures.
struct ErrorBannerView: View {
    let message: String
    let accessibilityIdentifier: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)

            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel(Text(String(localized: "accessibility.dismissError", bundle: .main)))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.red.opacity(0.25), lineWidth: 1)
        )
        .accessibilityIdentifier(accessibilityIdentifier)
        .accessibilityElement(children: .combine)
    }
}
