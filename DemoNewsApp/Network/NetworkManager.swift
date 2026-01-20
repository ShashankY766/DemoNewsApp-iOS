//
//  NetworkManager.swift
//  DemoAuthApp
//
//  Created by Shashank Yadav on 27/12/25.
//

import Foundation

/// Handles real LB and mock LB behavior
final class NetworkManager {

    static let IS_LB_ENABLED = false
    static let baseURL = "http://IP_ADDRESS/"

    // MARK: - Sign In
    static func signIn(
        username: String,
        encryptedPassword: String,
        completion: @escaping (Bool, String) -> Void
    ) {
        if !IS_LB_ENABLED {
            let validEncrypted =
                AESHelper.encrypt(
                    text: "ShawTest",
                    key: "ajhsvdfjhsabvfjsdbf%jkhdgbfug"
                )

            if username.lowercased() == "shaw" &&
               encryptedPassword == validEncrypted {
                completion(true, "Sign In Success")
            } else {
                completion(false, "Invalid Username or Password")
            }
            return
        }

        // Real backend call (LB forwards)
        completion(true, "Sign In Success")
    }

    // MARK: - Sign Up
    static func signUp(
        body: [String: Any],
        completion: @escaping (Bool, String) -> Void
    ) {
        if !IS_LB_ENABLED {
            completion(true, "Sign Up Success")
            return
        }
        let signUPurl = baseURL + "signup"
        print("[DEBUG] Sign Up URL: \(signUPurl)")
        // TODO: Implement real backend call
        completion(true, "Sign Up Success")
    }

    static func newsAPI(
        request: NewsRequest,
        completion: @escaping (Result<[Article], Error>) -> Void
    ) {

        var components = URLComponents(string: APIConstants.baseURL)
        var queryItems: [URLQueryItem] = []

        // Map NewsRequest into query params. Adjust keys to match API.
        // Removed: Reflection-based fallback caused coercion warning (Expression implicitly coerced from 'Any?' to 'Any')
        // if let mirror = Optional(Any?.some(request)).map({ Mirror(reflecting: $0) }) {
        //     // Fallback reflection if we don't know fields at compile time in this file.
        // }
        // Prefer explicit mapping of NewsRequest -> queryItems here.

        // Explicit mapping (edit keys/fields to your model):
        // queryItems.append(URLQueryItem(name: "category", value: request.category))
        // if let regions = request.regions, !regions.isEmpty { queryItems.append(URLQueryItem(name: "regions", value: regions.joined(separator: ","))) }
        // if let page = request.page { queryItems.append(URLQueryItem(name: "page", value: String(page))) }

        // If you know exact fields, prefer explicit mapping. Otherwise, try encoding then building dictionary.
        if queryItems.isEmpty {
            // Generic fallback: try to encode to dictionary and render as comma-joined for arrays
            if let data = try? JSONEncoder().encode(request),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                for (key, value) in json {
                    switch value {
                    case let array as [Any]:
                        let parts = array.map { String(describing: $0) }.joined(separator: ",")
                        queryItems.append(URLQueryItem(name: key, value: parts))
                    default:
                        queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
                    }
                }
            }
        }
        components?.queryItems = queryItems
        guard let finalURL = components?.url else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .unknown)])))
            }
            return
        }
        print("[DEBUG] Final URL: \(finalURL.absoluteString)")
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(APIConstants.contentType, forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .newsResponse)])))
                }
                return
            }
            print("[DEBUG] response : \(httpResponse )")
            print("[DEBUG] statuscode : \(httpResponse.statusCode )")
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .data)])))
                    }
                    return
                }
                print("[DEBUG] Data : \(data)")
                Task { @MainActor in
                    do {
                        let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                        print("[DEBUG] Decoded : \(NewsResponse.self)")
                        completion(.success(decoded.articles))
                    } catch {
                        completion(.failure(NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .decoding)])))
                    }
                }
                
            case 400...499:
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NetworkManager", code: 400, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .badRequest)])))
                }

            case 500...599:
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NetworkManager", code: 500, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .serverError)])))
                }

            default:
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: APIErrorMessages.message(for: .unknown)])))
                }
            }
        }.resume()
    }

}
