//
//  InputView.swift
//  EmployeeApp
//
//  Created by Monica Auriemma on 10/22/24.
//

import SwiftUI

// Reusable input component
struct InputView: View {
    // Variable from parent component
    @Binding var text: String
    
    // Component variables
    let title: String
    let placeholder: String
    var isSecuredField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color.gray)
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecuredField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
