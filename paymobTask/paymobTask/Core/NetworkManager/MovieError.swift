//
//  MovieError.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 25/08/2025.
//

import Foundation
enum MovieError: Error , Equatable{
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case other(errorMessage: String? = nil)
}
