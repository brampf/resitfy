//
//  File.swift
//  
//
//  Created by Max Schroeder on 24/03/20.
//

import Foundation
import Combine

extension URLSession {
    
    final class UploadTaskSubscription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (data: Data, response: URLResponse),
        SubscriberType.Failure == URLError
    {
        private var subscriber: SubscriberType?
        private weak var session: URLSession!
        private var request: URLRequest!
        private var task: URLSessionUploadTask!
        private var file: URL!
        
        init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {
                return
            }
            self.task = self.session.uploadTask(with: request, fromFile: file) { [weak self] data, response, error in
                if let error = error as? URLError {
                    self?.subscriber?.receive(completion: .failure(error))
                    return
                }
                guard let response = response else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                guard let data = data else {
                    self?.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                _ = self?.subscriber?.receive((data: data, response: response))
                self?.subscriber?.receive(completion: .finished)
            }
            self.task.resume()
        }

        func cancel() {
            self.task.cancel()
        }
    }
}

extension URLSession {

    public func uploadTaskPublisher(for url: URL, withFile: URL) -> URLSession.UploadTaskPublisher {
        self.uploadTaskPublisher(for: .init(url: url), withFile: withFile)
    }

    public func uploadTaskPublisher(for request: URLRequest, withFile: URL) -> URLSession.UploadTaskPublisher {
        .init(request: request, session: self, file: withFile)
    }

    public struct UploadTaskPublisher: Publisher {

        public typealias Output = (data: Data, response: URLResponse)
        public typealias Failure = URLError

        public let request: URLRequest
        public let session: URLSession
        public let file : URL

        public init(request: URLRequest, session: URLSession, file: URL) {
            self.request = request
            self.session = session
            self.file = file
        }

        public func receive<S>(subscriber: S) where S: Subscriber,
            UploadTaskPublisher.Failure == S.Failure,
            UploadTaskPublisher.Output == S.Input
        {
            let subscription = UploadTaskSubscription(subscriber: subscriber, session: self.session, request: self.request)
            subscriber.receive(subscription: subscription)
        }
    }
}

final class UploadTaskSubscriber: Subscriber {
    typealias Input = (data: Data, response: URLResponse)
    typealias Failure = URLError

    var subscription: Subscription?

    func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.unlimited)
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        print("Subscriber value \(String(data: input.data,encoding: .utf8) ?? "-")")
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<Failure>) {
        print("Subscriber completion \(completion)")
        self.subscription?.cancel()
        self.subscription = nil
    }
}
