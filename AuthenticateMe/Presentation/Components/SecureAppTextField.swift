//
//  SecureAppTextField.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - SecureAppTextField

/// Secure entry variant of `AppTextField` with visibility toggle.
struct SecureAppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let errorMessage: String?
    let textContentType: UITextContentType?
    let accessibilityIdentifier: String

    @State private var isSecure: Bool = true

    private var usePlainTextPasswordEntryForUITesting: Bool {
        ProcessInfo.processInfo.environment[UITestEnvironmentKey.plainTextPasswordFields.rawValue] == "1"
    }

    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String?,
        textContentType: UITextContentType? = .password,
        accessibilityIdentifier: String
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.textContentType = textContentType
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            if usePlainTextPasswordEntryForUITesting {
                TextField(placeholder, text: $text)
                    .textContentType(textContentType)
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
            } else {
                HStack(spacing: 8) {
                    Group {
                        if isSecure {
                            SecureField(placeholder, text: $text)
                        } else {
                            TextField(placeholder, text: $text)
                        }
                    }
                    .textContentType(textContentType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier(accessibilityIdentifier)
                    .accessibilityLabel(Text(title))

                    Button {
                        isSecure.toggle()
                    } label: {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel(Text(String(localized: "accessibility.togglePasswordVisibility", bundle: .main)))
                }
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
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("\(accessibilityIdentifier).error")
            }
        }
    }
}
