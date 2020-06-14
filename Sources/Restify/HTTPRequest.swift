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
import Combine

public struct EmptyBody : Codable {
    
}

public class HTTPRequest<Body: Encodable> {
    
    public let url : URLScheme
    public let method : String
    public private(set) var body : Body? = nil
    public private(set) var headers : [HTTPHeader]? = nil
    public private(set) var params: [URLParameter]? = nil
    
    public private(set) var expectedStatus: [HTTPStatus] = [.OK]
    
    init(url: URLScheme, method: String){
        self.url = url
        self.method = method
    }
    
    public func header(_ headers: HTTPHeader...) -> Self {
        self.headers = headers
        return self
    }
    
    public func query(_ parameters: URLParameter...) -> Self {
        self.params = parameters
        return self
    }
    
    public func body(_ body: Body) -> Self{
        self.body = body
        return self
    }

    public func send<Out: Decodable>(_ codes: HTTPStatus..., onError: ((Error) -> Void)? = nil, onCompletion: @escaping (Out) -> Void) {
        
        if let log = Restify.log{
            log.debug("\(self.debug())")
        }
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            execute(request: request, expectedStatusCodes: codes, onError: onError, onCompletion: onCompletion)
        } else {
            onError?(HTTPError.invalidURL)
        }
    }
    
    public func send(_ codes: HTTPStatus..., onError: ((Error) -> Void)? = nil, onCompletion: @escaping () -> Void) {
        
        if let log = Restify.log{
            log.debug("\(self.debug())")
        }
        
        if let request = self.request {
            let codes = expectedStatus.map{$0.code}
            execute(request: request, expectedStatusCodes: codes, onError: onError, onCompletion: onCompletion)
        } else {
            onError?(HTTPError.invalidURL)
        }
    }
}

extension HTTPRequest {
    
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
        
        var component = URLComponents()
        component.scheme = self.url.scheme
        component.host = self.url.host
        if let port = self.url.port {
            component.port = port
        }
        if let path = self.url.path {
            component.path = path
        }
        if let params = params {
            component.queryItems = params.map{$0.query}
        }
        
        guard let url = component.url else  {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        request.set(header: self.headers)
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }

        if let modifier = Restify.requestModifier {
            modifier(&request)
        }
        return request
    }

    
    func execute<OUT: Decodable>(request: URLRequest, expectedStatusCodes: [Int], onError: ((Error) -> Void)? = nil, onCompletion: @escaping (OUT) -> Void){
        
        session.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                
                if Restify.log != nil, let raw = String(data: output.data, encoding: .utf8) {
                    Restify.log?.debug("\(raw)")
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
            case .failure(let error): onError?(error)
            }
        }) { output in
            onCompletion(output)
        })
    }
    
    func execute(request: URLRequest, expectedStatusCodes: [Int], onError: ((Error) -> Void)? = nil, onCompletion: @escaping () -> Void){
        
        session.dataTaskPublisher(for: request)
            .tryMap{ output -> Data in
                
                guard let response = output.response as? HTTPURLResponse else {
                    throw HTTPError.invalidFormat
                }
                
                if Restify.log != nil, let raw = String(data: output.data, encoding: .utf8) {
                    Restify.log?.debug("\(raw)")
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
            case .failure(let error): onError?(error)
            }
        }) { output in
            onCompletion()
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

extension HTTPRequest {
    
    public func debug() {
        
        print("ME: \(type(of: self))")
        print(self)
        print(self.request?.debugDescription ?? "--")
        print(self.request?.httpBody ?? "--")
        
    }
    
    func what<T: Codable>(x : T) -> T.Type {
        return type(of: x)
    }
}
