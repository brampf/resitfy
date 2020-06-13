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

/// HTTP Header fields according to https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
/// with a little help from https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
public enum HTTPHeader {
    
    //request headers
    case Accept(String)
    case Authorization(String)
    case ContentType(String)
    case ContentLength(String)
    case ContentMD5(String)
    case ContentEncoding(String)
    case Date(String)
    case UserAgent(String)
    
    // response headers
    case LastModified(String)
    case ProxyAuthenticate(String)
    case PublicKeyPins(String)
    case WWWAuthenticate(String)
    case Via(String)
    
    // Custom header
    case header(String,String)
    
    var pair : (String,String) {
        switch self {
        case .Accept(let value): return ("Accept",value)
        case .Authorization(let value): return("Authorization",value)
        case .ContentType(let value): return ("Content-Type",value)
        case .ContentLength(let value): return ("Content-Length",value)
        case .ContentMD5(let value): return ("Content-MD5",value)
        case .ContentEncoding(let value): return ("Content-Encoding",value)
        case .Date(let value): return ("Date",value)
        case .UserAgent(let value): return ("User-Agent",value)
            
        case .LastModified(let value): return ("Last-Modified",value)
        case .ProxyAuthenticate(let value): return ("Proxy-Authenticate",value)
        case .PublicKeyPins(let value): return ("Public-Key-Pins",value)
        case .WWWAuthenticate(let value): return ("WWW-Authenticate",value)
        case .Via(let value): return ("Via",value)
            
        case .header(let name,let value): return (name,value)
        }
    }
}

extension URLRequest {
    
    mutating func set(header: HTTPHeader) {
        self.setValue(header.pair.0, forHTTPHeaderField: header.pair.1)
    }
    
    mutating func set(header: [HTTPHeader]?) {
        header?.forEach{ header in
            self.set(header: header)
        }
    }
    
}
