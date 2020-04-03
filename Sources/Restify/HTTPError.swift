//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation

public enum HTTPError : LocalizedError {
    case invalidFormat
    case wrongStatusCode(Int)
    case errorMessage(String)
    case errorCoded(CodableCustomStringConvertible)
    case emptyRequest
    case invalidURL
    
    
    public var errorDescription: String? {
        switch self {
        case .invalidFormat: return "The message was malformatted"
        case .wrongStatusCode(let code): return "Error Code \(code) does not match expecatiosn"
        case .errorMessage: return "Received error from server"
        case .errorCoded: return "Received error message from server"
        case .emptyRequest: return "Request did not return a proper response"
        case .invalidURL: return "The provided URL was malformatted"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidFormat: return "Invalid Format"
        case .wrongStatusCode(let code): return "Code \(code)"
        case .errorMessage(let message): return message
        case .errorCoded(let coded): return coded.description
        case .emptyRequest: return "Response was empty"
        case .invalidURL: return "Invalid URL"
        }
    }

}
