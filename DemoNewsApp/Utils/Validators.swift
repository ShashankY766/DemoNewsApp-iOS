//
//  Validators.swift
//  DemoAuthApp
//
//  Created by Shashank Yadav on 27/12/25.
//

import Foundation

/// Centralized validation logic
struct Validators {

    /// Password rules:
    /// - 6 to 10 characters
    /// - At least one alphabet
    /// - At least one number
    /// - At least one special character
    static func isValidPassword(_ password: String) -> Bool {

        let lengthValid = password.count >= 6 && password.count <= 10
        let hasAlphabet = password.range(of: "[A-Za-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil

        return lengthValid && hasAlphabet && hasNumber && hasSpecial
    }
}
