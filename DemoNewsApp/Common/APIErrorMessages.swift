//
//  APIErrorMessages.swift
//  DemoNewsApp
//
//  Created by Shashank Yadav on 30/12/25.
//
import Foundation

enum APIError: Error {
    case badRequest
    case serverError
    case unknown
    case newsResponse
    case data
    case decoding
}

struct APIErrorMessages {
    static func message(for error: APIError) -> String {
        switch error {
        case .badRequest:
            return "Please check request"
        case .serverError:
            return "Please check server"
        case .unknown:
            return "Something went wrong"
        case .newsResponse:
            return "No Response"
        case .data:
            return "No Data"
        case .decoding:
            return "Decoding failed"
        }
    }
}
