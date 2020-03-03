//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation

public  protocol URLScheme {
    
    var host : String {get}
    var port : Int? {get}
    var path : String? {get}
    var params : [URLParameter]? {get}
    
    var url : URL? {get}
}

extension URLScheme {
    
    func assemble(_ scheme: String, _ host: String,_ port : Int?, _ path: String?, _ params: [URLParameter]?) -> URL? {
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        if let port = port {
            component.port = port
        }
        if let path = path {
            component.path = path
        }
        
        if let params = params {
            component.queryItems = params.map{$0.query}
        }
        
        return component.url
        
    }
}

public struct HTTP : URLScheme {
    
    public let host: String
    public let port: Int?
    public let path: String?
    public let params: [URLParameter]?
    
    public var url : URL? {
        return assemble("http", host, port, path, params)
    }
}

public struct HTTPS : URLScheme {
    
    public let host: String
    public let port: Int?
    public let path: String?
    public let params: [URLParameter]?
    
    public var url : URL? {
        return assemble("https", host, port, path, params)
    }
}

public enum URLParameter {
    
    case parameter(String,String)
    
    var query : URLQueryItem {
        switch self {
        case .parameter(let p, let q): return URLQueryItem(name: p, value: q)
        }
    }
}
