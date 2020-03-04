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
    
    public var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
}

public struct POST<Body: Encodable> : HTTPRequestBody {
  
    public let url : URLScheme
    public let headers : [HTTPHeader]?
    public let body : Body
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, body: Body, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.body = body
        self.expectedStatus = expectedStatus
    }
    
    public var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
}

public struct PUT<Body : Encodable> : HTTPRequestBody {
    public let url : URLScheme
    public let headers : [HTTPHeader]?
    public let body : Body
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, body: Body, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.body = body
        self.expectedStatus = expectedStatus
    }
    
    public var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
}

public struct DELETE<Body : Encodable> : HTTPRequest {
    public let url : URLScheme
    public let headers : [HTTPHeader]?
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.expectedStatus = expectedStatus
    }
    
    public var request : URLRequest? {
        if let url = url.url {
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
}


