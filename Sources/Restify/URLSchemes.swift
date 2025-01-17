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

public protocol URLScheme {
    
    var scheme : String {get}
    var host : String {get}
    var port : Int? {get}
    var path : String? {get}
    
    //static func &(me: Self, path: String) -> Self
    //static func /(me: Self, params: [URLParameter]) -> Self
    
    
    init(host: String, port: Int?, path: String?)
}

precedencegroup SchemePrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator ⁄ : SchemePrecedence


public struct HTTP : HTTPScheme {

    public let scheme: String = "http"
    public let host: String
    public let port: Int?
    public let path: String?
    
    public init(host: String, port: Int? = nil, path: String? = nil){
        self.host = host
        self.port = port
        self.path = path
    }
}

public struct HTTPS : HTTPScheme {
    
    public let scheme: String = "https"
    public let host: String
    public let port: Int?
    public let path: String?

    public init(host: String, port: Int? = nil, path: String? = nil){
        self.host = host
        self.port = port
        self.path = path
    }
}

