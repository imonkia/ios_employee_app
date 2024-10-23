//
//  PasswordView.swift
//  EmployeeApp
//
//  Created by Monica Reta on 10/22/24.
//

import SwiftUI

struct PasswordView: View {
    // Parent variables
    @Binding var name: String
    @Binding var email: String
    
    // State variable
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // Env object instance
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Password field
                InputView(text: $password, title: "Password", placeholder: "Create a password", isSecuredField: true)
                
                // Sign Up button
                Button {
                    Task {
                        do {
                            try await viewModel.createuser(withEmail: email, password: password, fullname: name)
                        } catch AuthViewModel.FirebaseError.unknownError {
                            alertMessage = "Missing information - either email or name."
                            showAlert = true
                        }
                    }
                } label: {
                    HStack {
                        Text("Sign Up")
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
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
}

// Validation for password count requirement
extension PasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        password.count > 5
    }
}

#Preview {
    PasswordView(name: .constant(""), email: .constant(""))
        .environmentObject(AuthViewModel())
}
