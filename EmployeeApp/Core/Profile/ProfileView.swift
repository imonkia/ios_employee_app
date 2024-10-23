//
//  ProfileView.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/22/24.
//

import SwiftUI

struct ProfileView: View {
    // State variables to control button state
    @State var isCheckedIn: Bool = false
    @State var isCheckedOut: Bool = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    
    // Env object instance
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                // Check in button
                Button {
                    checkIn()
                    showAlert = true
                    alertTitle = "Checked In"
                    alertMessage = "You have checked in for the day."
                } label: {
                    Text("Check in")
                        .frame(minWidth: 150)
                        .padding()
                        .foregroundColor(.white)
                }
                .background(isCheckedIn ? Color.gray : Color.blue)
                .cornerRadius(10)
                .disabled(isCheckedIn)
                
                // Check out button
                Button {
                    checkOut()
                    showAlert = true
                    alertTitle = "Checked Out"
                    alertMessage = "You have checked out for the day."
                } label: {
                    Text("Check out")
                        .frame(minWidth: 150)
                        .padding()
                        .foregroundStyle(.white)
                }
                .background(isCheckedOut ? Color.gray : Color.blue)
                .cornerRadius(10)
                .disabled(isCheckedOut)
            }
            .padding(.top, 300)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Spacer()
            
            // Display Sign Out button if checked in and out already
            if isCheckedIn && isCheckedOut {
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign out")
                        .frame(minWidth: 150)
                        .padding()
                        .foregroundStyle(.white)
                }
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
    }
    
    // Declaring fucntion to check in
    func checkIn() {
        isCheckedIn = true
        // Persisting check in state between sessions
        UserDefaults.standard.set(true, forKey: "checkedIn")
    }
    
    // Declaring function to check out
    func checkOut() {
        isCheckedOut = true
        // Persisting check out state between sessions
        UserDefaults.standard.set(false, forKey: "checkedOut")
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
