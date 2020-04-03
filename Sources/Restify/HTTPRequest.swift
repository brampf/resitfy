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
    var method : String {get}
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
        request.httpMethod = self.method
        request.set(header: self.headers)
        request.httpBody = try? JSONEncoder().encode(body)
        if let modifier = Restify.requestModifier {
            modifier(&request)
        }
        return request
    }
    
    public func debug() {
        
        print("ME: \(type(of: self))")
        print(self)
        print(self.request?.debugDescription ?? "--")
        print(self.request?.httpBody ?? "--")
        
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
    
    public func upload(file: URL, completion: @escaping (Error?) -> Void) {
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return upload(request: request, file: file, expectedStatusCodes: codes, callback: completion)
        } else {
            return completion(HTTPError.invalidURL)
        }
    }
    
    public func download(completion: @escaping (URL?,Error?) -> Void) {
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return download(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            return completion(nil,HTTPError.invalidURL)
        }
    }
}

extension HTTPRequest {

    var session : URLSession {
        
        if Restify.sessionDelegeate != nil {
            return URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: Restify.sessionDelegeate!, delegateQueue: nil)
        } else {
            return URLSession.shared
        }
        
    }
    
     var request: URLRequest? {
        
        guard let url = self.url.url else  {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        if let modifier = Restify.requestModifier {
            modifier(&request)
        }
        return request
    }
    
    public func debug() {
        
        print("ME: \(type(of: self))")
        print(self)
        print(self.request?.debugDescription ?? "--")
        print(self.request?.httpBody ?? "--")
        
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
    
    public func upload(file: URL, completion: @escaping (Error?) -> Void) {
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return upload(request: request, file: file, expectedStatusCodes: codes, callback: completion)
        } else {
            return completion(HTTPError.invalidURL)
        }
    }
    
    public func download(completion: @escaping (URL?,Error?) -> Void) {
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            return download(request: request, expectedStatusCodes: codes, callback: completion)
        } else {
            return completion(nil,HTTPError.invalidURL)
        }
    }
    
    func what<T: Codable>(x : T) -> T.Type {
        return type(of: x)
    }
    
    func execute<OUT: Decodable>(request: URLRequest, expectedStatusCodes: [Int], callback: @escaping (OUT?,Error?) -> Void){
        
        session.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                if !expectedStatusCodes.contains(response.statusCode) {
                    
                    if let dec = Restify.errorDecoder, let err = dec(output.data) {
                        throw HTTPError.errorCoded(err)
                    } else if let errmsg = String(data: output.data, encoding: .utf8){
                        throw HTTPError.errorMessage(errmsg)
                    } else {
                        throw HTTPError.wrongStatusCode(response.statusCode)
                    }
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
        
        session.dataTaskPublisher(for: request)
            .tryMap{ output -> Data in
                
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                if !expectedStatusCodes.contains(response.statusCode) {
                    
                    if let dec = Restify.errorDecoder, let err = dec(output.data) {
                        throw HTTPError.errorCoded(err)
                    } else if let errmsg = String(data: output.data, encoding: .utf8){
                        throw HTTPError.errorMessage(errmsg)
                    } else {
                        throw HTTPError.wrongStatusCode(response.statusCode)
                    }
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
    
    func download(request: URLRequest, expectedStatusCodes: [Int], callback: @escaping (URL?,Error?) -> Void){
        
        URLSession.shared.downloadTaskPublisher(for: request)
            .tryMap{ output -> URL in
                
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                if !expectedStatusCodes.contains(response.statusCode) {
                    
                        throw HTTPError.wrongStatusCode(response.statusCode)
                }
                
                //var filename : String = response.
                
                return output.url
                
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
    
    func upload(request: URLRequest, file: URL, expectedStatusCodes: [Int], callback: @escaping (Error?) -> Void){
        
        URLSession.shared.uploadTaskPublisher(for: request, withFile: file)
            .tryMap{ output -> Data in
                
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                if !expectedStatusCodes.contains(response.statusCode) {

                        if let dec = Restify.errorDecoder, let err = dec(output.data) {
                            throw HTTPError.errorCoded(err)
                        } else if let errmsg = String(data: output.data, encoding: .utf8){
                            throw HTTPError.errorMessage(errmsg)
                        } else {
                            throw HTTPError.wrongStatusCode(response.statusCode)
                        }
                }
                
                //var filename : String = response.
                
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
