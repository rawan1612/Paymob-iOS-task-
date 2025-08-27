//
//  NetworkManager.swift
//  Appetizers App
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
//    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    
    // MARK: - The Basic URLSession Network Call with Parameters and Headers
    func getResponse<T: Codable>(
        url: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseClass: T.Type
    ) -> AnyPublisher<T, MovieError> {
        guard var urlComponents = URLComponents(string: url) else {
            return Fail(error: MovieError.invalidURL).eraseToAnyPublisher()
        }
        
        // Add parameters to the URL if any
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let finalURL = urlComponents.url else {
            return Fail(error: MovieError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        // Add headers to the request if any
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        print("Final URL: \(finalURL.absoluteString)")
        print("Headers: \(headers)")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
//                print("Response of \(finalURL) is: \(String(data: data, encoding: .utf8) ?? "No response")")
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw MovieError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> MovieError in
                switch error {
                case is URLError:
                    return .unableToComplete
                case is DecodingError:
                    return .invalidData
                default:
                    return .invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - The Basic URLSession Network Call for POST Request
    func postRequest<T: Codable>(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, responseClass: T.Type) -> AnyPublisher<T, MovieError> {
        guard let url = URL(string: url) else {
            return Fail(error: MovieError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Parameters: \(String(describing: parameters))")
        print("Headers: \(String(describing: headers))")
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        print("Final URL: \(url.relativeString)")
        print("Final URL: \(url.lastPathComponent)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: [])
            request.httpBody = jsonData
        } catch {
            return Fail(error: MovieError.invalidData).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Data: \(data), Response: \(response)")
                    throw MovieError.invalidResponse
                }
                print("Data: \(data), Response: \(response)")
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> MovieError in
                print("error: \(error.localizedDescription)")
                switch error {
                case is URLError:
                    return .unableToComplete
                case is DecodingError:
                    return .invalidData
                default:
                    return .invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Network Call using async, await
    func getResponse<T: Codable>(url: String, responseClass: T.Type) async throws -> T {
        guard let url = URL(string: url) else {
            print("invalidURL")
            throw MovieError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let responseObject = try JSONDecoder().decode(T.self, from: data)
            print("scusses")
            return responseObject
        } catch {
            print("invalidData")
            throw MovieError.invalidData
        }
    }
}
