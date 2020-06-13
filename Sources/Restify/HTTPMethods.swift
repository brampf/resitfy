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


