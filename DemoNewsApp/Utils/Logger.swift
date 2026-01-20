//
//  Logger.swift
//  DemoAuthApp
//
//  Created by Shashank Yadav on 27/12/25.
//

import Foundation

/// Simple debug logger
final class Logger {

    static func log(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        print("""
        🔍 LOG
        File: \((file as NSString).lastPathComponent)
        Function: \(function)
        Line: \(line)
        Message: \(message)
        ---------------------
        """)
        #endif
    }
}
