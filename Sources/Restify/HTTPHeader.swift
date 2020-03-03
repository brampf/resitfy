//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation

/// HTTP Header fields according to https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
/// with a little help from https://en.wikipedia.org/wiki/List_of_HTTP_header_fields
public enum HTTPHeader {
    
    case accept(String)
    case contentType(String)
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
        case .accept(let value): return ("Accept",value)
        case .contentType(let value): return ("Content-Type",value)
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
