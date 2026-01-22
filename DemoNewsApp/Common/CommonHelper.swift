//
//  CommonHelper.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 27/12/25.
//
//  - This file is compatible with BOTH UIKit and SwiftUI
//  - SwiftUI views can access these helpers via their
//    underlying UIHostingController
//

import UIKit

// MARK: - App Configuration
struct AppConfig {

    /// Toggle LB usage
    static let IS_LB_ENABLED: Bool = true

    /// Dev backend URL
    static let BASE_URL: String = "http://IP_ADDRESS/"
}

// Common Helper

final class CommonHelper {

    // MARK: - ALERT (SAFE, MAIN THREAD)

    /// Presents an alert safely on the main thread
    /// - Parameters:
    ///   - viewController: UIViewController on which alert is shown
    ///   - title: Alert title
    ///   - message: Alert message
    ///
    /// - Call this using the hosting UIViewController
    static func showAlert(
        on viewController: UIViewController,
        title: String,
        message: String
    ) {

        DispatchQueue.main.async {

            // Prevent alerts stacking
            if viewController.presentedViewController is UIAlertController {
                return
            }

            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(title: "OK", style: .default)
            )

            viewController.present(alert, animated: true)
        }
    }

    // MARK: - USERNAME VALIDATION

    /// Validates username input
    static func validateUsername(
        _ username: String,
        on viewController: UIViewController
    ) -> Bool {

        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(
                on: viewController,
                title: "Invalid Username",
                message: "Username is mandatory"
            )
            return false
        }
        return true
    }

    // MARK: - MOBILE NUMBER VALIDATION

    /// Validates mobile number input
    static func validateMobile(
        _ mobile: String,
        on viewController: UIViewController
    ) -> Bool {

        if mobile.isEmpty {
            showAlert(
                on: viewController,
                title: "Invalid Mobile Number",
                message: "Mobile number is mandatory"
            )
            return false
        }

        if mobile.count < 8 || mobile.count > 15 {
            showAlert(
                on: viewController,
                title: "Invalid Mobile Number",
                message: "Please enter a valid mobile number"
            )
            return false
        }

        return true
    }

    // PASSWORD VALIDATION

    /// Validates password against regex rules
    static func validatePassword(
        _ password: String,
        on viewController: UIViewController
    ) -> Bool {

        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{6,10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

        if !predicate.evaluate(with: password) {
            showAlert(
                on: viewController,
                title: "Invalid Password",
                message: """
                Password must:
                • Be 6–10 characters
                • Contain a letter
                • Contain a number
                • Contain a special character
                """
            )
            return false
        }

        return true
    }

    // LOGGING (DEBUG ONLY)

    /// Debug-only structured logging
    static func log(
        _ message: String,
        function: String = #function,
        file: String = #file
    ) {

        #if DEBUG
        print("""
        =========================
        [DEBUG LOG]
        File: \(file)
        Function: \(function)
        Message: \(message)
        =========================
        """)
        #endif
    }

    // Navigation Bar Appearance

    /// Applies orange navigation bar appearance used by UIKit view controllers
    /// SwiftUI screens using UINavigationController will also inherit this appearance
    static func UINavigationBerAppearanceOrange(
        navigationController: UINavigationController
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemOrange
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}
