//
//  File.swift
//  
//
//  Created by Max Schroeder on 05/03/20.
//

import Foundation

public typealias CodableCustomStringConvertible = Codable & CustomStringConvertible

public struct Restify {
    
    public static var requestModifier : ((_ request: inout URLRequest) -> Void)?
    public static var errorDecoder : ((Data) -> CodableCustomStringConvertible?)?
}
