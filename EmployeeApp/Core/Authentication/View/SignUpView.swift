//
//  SignUpView.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/22/24.
//

import SwiftUI

struct SignUpView: View {
    // State variables
    @State private var name: String = ""
    @State private var email: String = ""
    
    // Env object instance
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 24) {
                    InputView(text: $name, title: "Name", placeholder: "Full Name")
                    
                    InputView(text: $email, title: "Email", placeholder: "name@example.com")
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // "Next" button
                NavigationLink {
                    PasswordView(name: $name, email: $email)
                } label: {
                    HStack {
                        Text("Next")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.blue)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1 : 0.3)
                .cornerRadius(10)
                .padding(.top, 24)
                
                // Redirect to log in view
                NavigationLink {
                    LoginView()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Log in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .padding(.vertical, 50)
                }
            }
            .navigationTitle("Sign Up")
        }
    }
}

// Validations for name and email fields
extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !name.isEmpty
    }
}

#Preview {
    SignUpView()
}
