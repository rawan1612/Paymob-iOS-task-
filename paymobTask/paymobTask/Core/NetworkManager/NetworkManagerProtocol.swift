//
//  NetworkManagerProtocol.swift
//  Appetizers App
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import Combine

protocol NetworkManagerProtocol {
    func getResponse<T: Codable>(url: String, parameters: [String: Any]?, headers: [String: String]?, responseClass: T.Type) -> AnyPublisher<T, MovieError>
    func postRequest<T: Codable>(url: String, parameters: [String: Any]?, headers: [String: String]?, responseClass: T.Type) -> AnyPublisher<T, MovieError>
}

extension NetworkManagerProtocol {
    func getResponse<T: Codable>(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, responseClass: T.Type) -> AnyPublisher<T, MovieError> {
        self.getResponse(url: url, parameters: parameters, headers: headers, responseClass: responseClass)
    }
    func postRequest<T: Codable>(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, responseClass: T.Type) -> AnyPublisher<T, MovieError> {
        self.postRequest(url: url, parameters: parameters, headers: headers, responseClass: responseClass)
    }
}
