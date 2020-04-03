//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation


public struct GET : HTTPRequest {

    public let url : URLScheme
    public let method : String = "GET"
    public let headers : [HTTPHeader]?
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.expectedStatus = expectedStatus
    }
}

public struct POST<Body: Encodable> : HTTPRequestBody {
  
    public let url : URLScheme
    public let method : String = "POST"
    public let headers : [HTTPHeader]?
    public let body : Body
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, body: Body, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.body = body
        self.expectedStatus = expectedStatus
    }
}

public struct PUT<Body : Encodable> : HTTPRequestBody {
    public let url : URLScheme
    public let method : String = "PUT"
    public let headers : [HTTPHeader]?
    public let body : Body
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, body: Body, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.body = body
        self.expectedStatus = expectedStatus
    }
}

public struct DELETE : HTTPRequest {
    public let url : URLScheme
    public let method: String = "DELETE"
    public let headers : [HTTPHeader]?
    public let expectedStatus: [HTTPStatus]
    
    public init(url: URLScheme, headers: [HTTPHeader]? = nil, expectedStatus: [HTTPStatus]){
        self.url = url
        self.headers = headers
        self.expectedStatus = expectedStatus
    }
}


