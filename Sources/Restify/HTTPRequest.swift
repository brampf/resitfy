//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation
import Combine

protocol HTTPRequest {
    
    var url : URLScheme { get }
    var headers : [HTTPHeader]? { get }
    var expectedStatus : [HTTPStatus] { get }
    
    var request : URLRequest? { get }
    func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void)
}

extension HTTPRequest {
    
    func execute<OUT: Decodable>(request: URLRequest, expectedStatusCodes: [Int], callback: @escaping (OUT?,Error?) -> Void){
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                if !expectedStatusCodes.contains(response.statusCode) {
                    throw HTTPError.wrongStatusCode(response.statusCode)
                }
                
                return output.data
        }
        .decode(type: OUT.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .receive(subscriber: Subscribers.Sink(receiveCompletion: { completion in
            switch completion {
            case .finished: break // allright
            case .failure(let error): callback(nil,error)
            }
        }) { output in
            callback(output,nil)
        })
    }
    
    func executeEmpty<OUT: Any>(request: URLRequest, expectedStatusCodes: [Int], callback: @escaping (OUT?,Error?) -> Void){
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                if !expectedStatusCodes.contains(response.statusCode) {
                    throw HTTPError.wrongStatusCode(response.statusCode)
                }
                
                return output.data
                
        }
        .eraseToAnyPublisher()
        .receive(subscriber: Subscribers.Sink(receiveCompletion: { completion in
            switch completion {
            case .finished: break // allright
            case .failure(let error): callback(nil,error)
            }
        }) { output in
            callback(nil,nil)
        })
    }
}
