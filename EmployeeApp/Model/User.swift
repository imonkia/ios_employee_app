//
//  User.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/22/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Almond Auriemma", email: "name@example.com")
}
