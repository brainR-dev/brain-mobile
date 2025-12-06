//
//  SignUpView.swift
//  BrainRush
//
//  Sign up view
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var authService = AuthService.shared
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password, confirmPassword
    }
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 8
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo/Header
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                Text("Join BrainRush")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Start your learning journey")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Sign Up Form
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .confirmPassword)
                
                if !password.isEmpty && password.count < 8 {
                    Text("Password must be at least 8 characters")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if !confirmPassword.isEmpty && password != confirmPassword {
                    Text("Passwords do not match")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: signUp) {
                    if authService.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    } else {
                        Text("Sign Up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(authService.isLoading || !isFormValid)
                
                // OAuth Buttons
                VStack(spacing: 12) {
                    Divider()
                        .overlay(
                            Text("OR")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .background(Color(.systemBackground))
                        )
                    
                    Button(action: signUpWithGoogle) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Continue with Google")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                    .disabled(authService.isLoading)
                    
                    Button(action: signUpWithApple) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                    .disabled(authService.isLoading)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Sign In Link
            HStack {
                Text("Already have an account?")
                Button("Sign In") {
                    // Navigate to sign in
                }
                .foregroundColor(.blue)
            }
            .font(.footnote)
            .padding(.bottom, 40)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authService.errorMessage ?? "An error occurred")
        }
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            case .password:
                focusedField = .confirmPassword
            case .confirmPassword:
                if isFormValid {
                    signUp()
                }
            case .none:
                break
            }
        }
    }
    
    private func signUp() {
        Task {
            do {
                try await authService.signUp(email: email, password: password)
            } catch {
                showError = true
            }
        }
    }
    
    private func signUpWithGoogle() {
        Task {
            do {
                try await authService.signInWithGoogle()
            } catch {
                showError = true
            }
        }
    }
    
    private func signUpWithApple() {
        Task {
            do {
                try await authService.signInWithApple()
            } catch {
                showError = true
            }
        }
    }
}

#Preview {
    SignUpView()
}
