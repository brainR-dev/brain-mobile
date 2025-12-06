//
//  SignInView.swift
//  BrainRush
//
//  Sign in view
//

import SwiftUI

struct SignInView: View {
    @StateObject private var authService = AuthService.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo/Header
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                Text("BrainRush")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Learn. Earn. Level Up.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Sign In Form
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                
                Button(action: resetPassword) {
                    Text("Forgot Password?")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button(action: signIn) {
                    if authService.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    } else {
                        Text("Sign In")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(authService.isLoading || email.isEmpty || password.isEmpty)
                
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
                    
                    Button(action: signInWithGoogle) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Continue with Google")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                    .disabled(authService.isLoading)
                    
                    Button(action: signInWithApple) {
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
            
            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                Button("Sign Up") {
                    // Navigate to sign up
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
                signIn()
            case .none:
                break
            }
        }
    }
    
    private func signIn() {
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                showError = true
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            do {
                try await authService.signInWithGoogle()
            } catch {
                showError = true
            }
        }
    }
    
    private func signInWithApple() {
        Task {
            do {
                try await authService.signInWithApple()
            } catch {
                showError = true
            }
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            showError = true
            authService.errorMessage = "Please enter your email address"
            return
        }
        
        Task {
            do {
                try await authService.resetPassword(email: email)
                // Show success message
            } catch {
                showError = true
            }
        }
    }
}

#Preview {
    SignInView()
}
