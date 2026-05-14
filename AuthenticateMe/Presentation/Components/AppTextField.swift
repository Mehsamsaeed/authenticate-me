//
//  AppTextField.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - AppTextField

/// Reusable single-line text field with title, validation messaging, and accessibility hooks.
struct AppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let errorMessage: String?
    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let accessibilityIdentifier: String

    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String?,
        textContentType: UITextContentType? = nil,
        keyboardType: UIKeyboardType = .default,
        accessibilityIdentifier: String
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.textContentType = textContentType
        self.keyboardType = keyboardType
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textContentType(textContentType)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(errorMessage == nil ? Color.clear : Color.red.opacity(0.55), lineWidth: 1)
                )
                .accessibilityIdentifier(accessibilityIdentifier)
                .accessibilityLabel(Text(title))

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("\(accessibilityIdentifier).error")
            }
        }
    }
}
