//
//  AuthViewModel.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/22/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

// Validate input fields in a form
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}


// Publish all UI updates back on the main thread
@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var hasError: Bool = false
    @Published var errorMessage: String? = nil
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // Async throwable function to log in
    func logIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
            throw FirebaseError.invalidCredentials
        }
    }
    
    // Async throwable function to create user
    func createuser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Creating user using Firebase code
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // Setting user session property
            self.userSession = result.user
            // Create our User object
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            // Encode the user into json data using Firebase's encoder protocol
            let encodedUser = try Firestore.Encoder().encode(user)
            // Upload data to Firestore
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw FirebaseError.unknownError
        }
    }
    
    // Function to sign user out
    func signOut() {
        do {
            // Sign user out on backend
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign user out \(error.localizedDescription)")
        }
    }
    
    // Fetch user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    // Custom errors
    enum FirebaseError: Error {
        case invalidCredentials
        case networkError
        case unknownError
    }
}
