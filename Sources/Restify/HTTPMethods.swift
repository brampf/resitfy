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


public protocol HTTPScheme : URLScheme {

    

}

extension HTTPScheme {

    
    public static func ⁄(me: Self, path: String) -> Self {
        return Self(host: me.host, port: me.port, path: path)
    }
    
    public static func ⁄(me: Self, params: [URLParameter]) -> Self {
        return Self(host: me.host, port: me.port, path: me.path)
    }
    
    public typealias GET = HTTPRequest<EmptyBody>
    public typealias POST = HTTPRequest
    public typealias PUT = HTTPRequest
    public typealias DELETE = HTTPRequest<EmptyBody>
    
    public func GET(_ endpoint: String) -> Self.GET{
        return Self.GET(url: self⁄endpoint, method: "GET")
    }
    
    public func POST<Body : Encodable>(_ endpoint: String) -> Self.POST<Body>{
        return Self.POST(url: self⁄endpoint, method: "POST")
    }
    
    public func POST(_ endpoint: String) -> Self.POST<EmptyBody>{
        return Self.POST(url: self⁄endpoint, method: "POST")
    }
    
    public func PUT<Body : Encodable>(_ endpoint: String) -> Self.PUT<Body>{
        return Self.PUT(url: self⁄endpoint, method: "PUT")
    }
    
    public func PUT(_ endpoint: String) -> Self.PUT<EmptyBody>{
        return Self.PUT(url: self⁄endpoint, method: "PUT")
    }
    
    public func DELTE(_ endpoint: String) -> Self.GET{
        return Self.DELETE(url: self⁄endpoint, method: "DELTE")
    }

}
