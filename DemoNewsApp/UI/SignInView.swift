//
//  SignInView.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 17/01/26.
//

import SwiftUI

/// ------------------------------------------------------------
/// SignInView (SwiftUI)
/// ------------------------------------------------------------
/// - Tap outside text fields → dismiss keyboard
/// - Button disabled during sign-in
/// - State reset on re-appear
/// - Programmatic navigation
/// ------------------------------------------------------------
struct SignInView: View {

    // State (UIKit ivars equivalent)
    
  //  @Binding var text: String

    @FocusState private var isFocused: Bool
        
    @State private var username: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var password: String = ""
    @State private var isSigningIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToNews: Bool = false

    // Focus (Keyboard handling)

    @FocusState private var focusedField: Field?

    private enum Field {
        case username
        case password
    }

    // Constants

    private let buttonHeight: CGFloat = 48

    // Body

    var body: some View {

        ZStack {

            /// Background gradient
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                ScrollView {

                    VStack(spacing: 12) {

                        /// App Image
                        Image("DemoNewsApp")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.secondary, lineWidth: 3)
                            )
                            .background(Color(.secondarySystemBackground))

                        /// Title
                        Text("Sign In")
                            .font(.system(size: 32, weight: .bold))
                            .padding(.top, 20)

                        /// Username Label
                        Text("Username")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        /// Username Field
                        TextField("Email ID / Mobile Number", text: $username)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .username)
                            .onSubmit {
                                focusedField = .password
                            }
              /*              .onChange(of: isFocused) { focused in
                                                if !focused {
                                                    validateInput()
                                                }
                                            }*/
               /*             .onChange(of: isFocused) { oldValue, newValue in
                                if oldValue == true && newValue == false {
                                    validateInput()
                                }
                            }   */
                        
                            .onChange(of: focusedField) { oldValue, newValue in
                                if oldValue == .username && newValue != .username {
                                    validateInput()
                                }
                            }
                        
                        if showError {
                                        Text(errorMessage)
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .alignmentGuide(HorizontalAlignment.leading) { d in
                                                d[HorizontalAlignment.leading]
                                            }
                                    }

                        /// Password Label
                        Text("Password")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        /// Password Field
                        SecureField("Password", text: $password)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .submitLabel(.go)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                focusedField = nil
                                signInTapped()
                            }

                        Spacer(minLength: 120)
                    }
                    .padding(.top, 100)
                    .padding(.horizontal, 36)
                }

                /// Sign In Button
                Button(action: signInTapped) {
                    Text("Sign In")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonHeight)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .disabled(isSigningIn)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationDestination(isPresented: $navigateToNews) {
            NewsView()
        }
        
        //Dismiss keyboard when tapping outside
        .onTapGesture {
            focusedField = nil
        }

        /// viewWillAppear equivalent
        .onAppear {
            isSigningIn = false
            navigateToNews = false
        }

        .navigationBarHidden(true)

        /// Alert
        .alert("User Input Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // Actions
    
    private func validateInput() {
            let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
            print("DEBUG - username: \(trimmed)")
       /*     if trimmed.isEmpty {
                showError = true
                errorMessage = "This field cannot be empty"
                return
            }*/

            if isValidEmail(trimmed) || isValidMobile(trimmed) {
                showError = false
                errorMessage = ""
            } else {
                showError = true
                errorMessage = "Enter a valid Email ID or Mobile Number"
            }
        }

        private func isValidEmail(_ value: String) -> Bool {
            let emailRegex =
            "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex)
                .evaluate(with: value)
        }

        private func isValidMobile(_ value: String) -> Bool {
            // 10-digit mobile number (India-style, can be adjusted)
            let mobileRegex = "^[6-9]\\d{9}$"
            return NSPredicate(format: "SELF MATCHES %@", mobileRegex)
                .evaluate(with: value)
        }

    private func signInTapped() {
        if isSigningIn { return }
        focusedField = nil
        isSigningIn = true
        performSignIn()
    }

    private func performSignIn() {

        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter both email and password"
            showAlert = true
            isSigningIn = false
            return
        }

        let encryptedPassword = AESHelper.encrypt(
            text: password,
            key: "ajhsvdfjhsabvfjsdbf%jkhdgbfug"
        )!

        NetworkManager.signIn(
            username: username,
            encryptedPassword: encryptedPassword
        ) { success, message in
            DispatchQueue.main.async {
                if success {
                    navigateToNews = true
                } else {
                    alertMessage = message
                    showAlert = true
                    username = ""
                    password = ""
                    isSigningIn = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
