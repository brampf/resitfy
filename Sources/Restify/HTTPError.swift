//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation

public enum HTTPError : Error {
    case invalidFormat
    case wrongStatusCode(Int)
    case emptyRequest
    case invalidURL
    
    var localizedDescription: String{
        switch self {
        case .invalidFormat: return "Invalid Format"
        case .wrongStatusCode(let code): return "Got code \(code)"
        case .emptyRequest: return "Response was empty"
        case .invalidURL: return "Invalid URL"
        }
    }
}
