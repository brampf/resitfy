/*
 
 Copyright (c) <2020>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

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
