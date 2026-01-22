//
//  UIHelper.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 27/12/25.
//
//  - Shared UI helper utilities
//  - Background gradient support
//  - Header label styling
//
//  IMP:
//  - Function names, parameters, and return types are NOT changed
//  - Safe to use from both UIKit and SwiftUI
//

import UIKit

/// ------------------------------------------------------------
/// Applies a blue → white background gradient to a UIView
/// ------------------------------------------------------------
///     applyBackgroundGradient(view: self.view)
///
/// SwiftUI usage:
///     Call on the underlying UIHostingController's view
/// ------------------------------------------------------------
func applyBackgroundGradient(view: UIView) {

    // Remove existing gradient layers to prevent stacking
    view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

    let gradient = CAGradientLayer()
    gradient.colors = [
        UIColor.systemBlue.cgColor,
        UIColor.white.cgColor
    ]
    gradient.locations = [0.0, 1.0]
    gradient.frame = view.bounds

    view.layer.insertSublayer(gradient, at: 0)
}

/// ------------------------------------------------------------
/// Creates a gradient-colored header UILabel
/// ------------------------------------------------------------
///     let label = headerLabel(text: "Sign In")
///
/// SwiftUI usage:
///     Can be embedded via UIViewRepresentable if needed
/// ------------------------------------------------------------
func headerLabel(text: String) -> UILabel {

    let label = UILabel()
    label.text = text
    label.font = .boldSystemFont(ofSize: 30)
    label.textAlignment = .center

    let gradient = CAGradientLayer()
    gradient.colors = [
        UIColor.systemBlue.cgColor,
        UIColor.systemPurple.cgColor
    ]
    gradient.frame = CGRect(x: 0, y: 0, width: 250, height: 40)

    UIGraphicsBeginImageContext(gradient.frame.size)
    gradient.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    label.textColor = UIColor(patternImage: image!)
    return label
}
