//
//  CountryCode.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 27/12/25.
//

import Foundation

/// Country model for dialing code handling
/// Only `dialCode` is sent to backend
struct CountryCode {
    let name: String          // India
    let dialCode: String      // 91
    let displayText: String  // India +91
}

struct CountryCodeData {
    static let supported: [CountryCode] = [
        CountryCode(name: "India", dialCode: "91", displayText: "India +91"),
        CountryCode(name: "USA", dialCode: "1", displayText: "USA +1"),
        CountryCode(name: "UK", dialCode: "44", displayText: "UK +44")
    ]
}
