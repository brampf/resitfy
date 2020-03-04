//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation


public struct GET : HTTPRequest {
    public let url : URLScheme
    public let headers : [HTTPHeader]?
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.expectedStatus = expectedStatus
    }
    
    var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void) {
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return execute(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            completion(nil,HTTPError.invalidURL)
        }
    }
}

public struct POST<Body: Encodable> : HTTPRequest {
  
    let url : URLScheme
    let headers : [HTTPHeader]?
    let body : Body
    let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, body: Body, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.body = body
        self.expectedStatus = expectedStatus
    }
    
    var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void) {
        if var request = self.request {
            request.httpBody = try? JSONEncoder().encode(body)
            let codes = expectedStatus.map{$0.code}
            return execute(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            completion(nil,HTTPError.invalidURL)
        }
    }
}

public struct PUT<Body : Encodable> : HTTPRequest {
    let url : URLScheme
    let headers : [HTTPHeader]?
    let body : Body
    let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, body: Body, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.body = body
        self.expectedStatus = expectedStatus
    }
    
    var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void) {
        if var request = self.request {
            request.httpBody = try? JSONEncoder().encode(body)
            let codes = expectedStatus.map{$0.code}
            return execute(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            completion(nil,HTTPError.invalidURL)
        }
    }
}

public struct DELETE<Body : Encodable> : HTTPRequest {
    let url : URLScheme
    let headers : [HTTPHeader]?
    let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.expectedStatus = expectedStatus
    }
    
    var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void) {
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return executeEmpty(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            completion(nil,HTTPError.invalidURL)
        }
    }
}


