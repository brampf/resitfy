//
//  File.swift
//  
//
//  Created by May on 03.03.20.
//

import Foundation
import Combine

public protocol HTTPRequest {
    
    var url : URLScheme { get }
    var headers : [HTTPHeader]? { get }
    var expectedStatus : [HTTPStatus] { get }
    
    func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void)
    func send(completion: @escaping (Error?) -> Void)
}

public protocol HTTPRequestBody : HTTPRequest {
    associatedtype Body : Encodable

    var body : Body { get }
}

extension HTTPRequestBody {
    
    var request: URLRequest? {
        
        guard let url = self.url.url else  {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpBody = try? JSONEncoder().encode(body)
        if let modifier = Restify.requestModifier {
            modifier(&request)
        }
        return request
    }
    
}

extension HTTPRequest {

     var request: URLRequest? {
        
        guard let url = self.url.url else  {
            return nil
        }
        var request = URLRequest(url: url)
        if let modifier = Restify.requestModifier {
            modifier(&request)
        }
        return request
    }
    
    
    public func send<OUT: Decodable>(completion: @escaping (OUT?,Error?) -> Void) {

        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return execute(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            return completion(nil,HTTPError.invalidURL)
        }
    }
    
    public func send(completion: @escaping (Error?) -> Void) {
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return execute(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            return completion(HTTPError.invalidURL)
        }
    }
    
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
    
    func execute(request: URLRequest, expectedStatusCodes: [Int], callback: @escaping (Error?) -> Void){
        
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
            case .failure(let error): callback(error)
            }
        }) { output in
            callback(nil)
        })
    }
}
