//
//  LoginView.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/22/24.
//

import SwiftUI

struct LoginView: View {
    // State variables
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // Env object instance
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Log in button
                Button {
                    Task {
                        do {
                            try await viewModel.logIn(withEmail: email, password: password)
                        } catch AuthViewModel.FirebaseError.invalidCredentials {
                            alertMessage = "Invalid credentials or user not found."
                            showAlert = true
                        } catch AuthViewModel.FirebaseError.networkError {
                            alertMessage = "Network error."
                            showAlert = true
                        }
                    }
                } label: {
                    HStack {
                        Text("Log in")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.blue)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1 : 0.3)
                .cornerRadius(10)
                .padding(.top, 24)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Unable to log in"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle("Log In")
        }
    }
}

// Validations for email and password fields
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
