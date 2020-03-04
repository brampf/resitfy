//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation

public protocol URLScheme {
    
    var host : String {get}
    var port : Int? {get}
    var path : String? {get}
    var params : [URLParameter]? {get}
    
    var url : URL? {get}
    
    //static func &(me: Self, path: String) -> Self
    //static func /(me: Self, params: [URLParameter]) -> Self
}

precedencegroup SchemePrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator ⁄ : SchemePrecedence

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
    
    public init(host: String, port: Int? = nil, path: String? = nil, params: [URLParameter]? = nil){
        self.host = host
        self.port = port
        self.path = path
        self.params = params
    }

    public static func ⁄(me: Self, path: String) -> Self {
        return Self(host: me.host, port: me.port, path: path, params: me.params)
    }
    
    public static func ⁄(me: Self, params: [URLParameter]) -> Self {
        return Self(host: me.host, port: me.port, path: me.path, params: params)
    }
    
    public var url : URL? {
        return assemble("http", host, port, path, params)
    }
}

public struct HTTPS : URLScheme {
    
    public let host: String
    public let port: Int?
    public let path: String?
    public let params: [URLParameter]?
    
    public init(host: String, port: Int? = nil, path: String? = nil, params: [URLParameter]? = nil){
        self.host = host
        self.port = port
        self.path = path
        self.params = params
    }
    
    public static func ⁄(me: Self, path: String) -> Self {
        return Self(host: me.host, port: me.port, path: path, params: me.params)
    }
   
    public static func ⁄(me: Self, params: [URLParameter]) -> Self {
        return Self(host: me.host, port: me.port, path: me.path, params: params)
    }
    
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
