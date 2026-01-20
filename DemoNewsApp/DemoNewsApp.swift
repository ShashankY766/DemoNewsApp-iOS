//
//  DemoNewsAppApp.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 17/01/26.
//

import SwiftUI
/*
@main
struct DemoNewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/

//
//  DemoNewsApp.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 27/12/25.
//

/// ------------------------------------------------------------
/// Application Entry Point (SwiftUI)
/// ------------------------------------------------------------
/// This file replaces:
/// - SceneDelegate.swift
/// - UIWindow creation and management
/// - UINavigationController setup
///
/// SwiftUI automatically manages:
/// - App lifecycle
/// - Window lifecycle
/// - Scene lifecycle
///
/// Navigation is handled using NavigationStack,
/// which is the SwiftUI equivalent of UINavigationController.
/// ------------------------------------------------------------
@main
struct DemoNewsApp: App {

    /// --------------------------------------------------------
    /// App Body
    /// --------------------------------------------------------
    /// - WindowGroup creates and manages the app window
    /// - NavigationStack provides stack-based navigation
    /// - Root view is SignInView (same as UIKit root VC)
    /// --------------------------------------------------------
    var body: some Scene {
        WindowGroup {

            /// NavigationStack replaces UINavigationController
            NavigationStack {

                /// Root screen of the application
                /// UIKit equivalent:
                /// let rootVC = SignInViewController()
                /// UINavigationController(rootViewController: rootVC)
                SignInView()
            }
        }
    }
}

