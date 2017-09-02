//
//  APIError.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Moya

enum APIError: Swift.Error {
    
    case notFound
    case giphyError
    case unknown(message: String)
    case moyaError(message: String)
    
    init(code: Int, message: String?) {
        switch code {
        case 404:
            self = .notFound
        case 500:
            self = .giphyError
        default:
            self = .unknown(message: message ?? "Unknown error occured during the process.")
        }
    }
    
    init(error: NSError) {
        self = .unknown(message: error.localizedDescription)
    }
    
    init(error: Swift.Error) {
        self = .unknown(message: error.localizedDescription)
    }
    
    init(error: MoyaError) {
        self = .moyaError(message: error.localizedDescription)
    }
}

extension APIError: Equatable {
    
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound): return true
        case (.giphyError, .giphyError): return true
        default:
            return false
        }
    }
}

// MARK: - Error Descriptions

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .giphyError:
            return "Server error took place during operation."
        case .notFound:
            return "The object is not found."
        case .moyaError(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}

