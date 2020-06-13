<p align="center">
<img src = "Doc/RestifyBanner@0.5x.png" alt="FitsCore">
</p>

<p align="center">
<a href="LICENSE">
<img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
<a href="https://swift.org">
<img src="https://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
</a>
</p>

A Swift library to build REST client applications 

## Description

Since REST is so common these days, implementing REST interfaces in [Swift](https://swift.org)  requires a lot of boilderplate code. This library provides a extremely straightforward approach to implement those quick and sometimes even dirty ;)

## Getting started

### Package Manager

With the swift package manager, add the library to your dependencies
```swift
dependencies: [
    .package(url: "https://github.com/brampf/restify.git", from: "0.1.0")
]
```

then simply add the `Restify` import to your target

```swift

.target(name: "YourApp", dependencies: ["Restify"])
```

## Documentation

### TL;DR

To check if a `GET` to  `http://domain.tld/api/version` returns a `200 OK`, it needs  only two lines of code (not counting the trainling bracket ;))
```swift

// crate request by extending the base URL
GET(url: HTTP(host: "domain.tld", path: "/api")⁄"version", expectedStatus: [.OK]).send { error in
    // error == nil if Server returned 200 OK
    if error != nil { print("Server did not return 200 OK") }
}
```

### GET / POST / PUT

```swift

let baseURL = HTTP(host: "domain.tld", path: "/api")

GET(url: baseURL⁄"ENDPOINT", headers: [.UserAgent("Restify")], expectedStatus: [.OK]).send { output, error in
    if output == "Pong" { print("Allright!") }
    if let error = error { print(error) }
}

POST(url: baseURL⁄"ENDPOINT", headers: [.UserAgent("Restify")], body: "Ping", expectedStatus: [.OK]).send { output, error in
    if output == "Pong" { print("Allright!") }
    if let error = error { print(error) }
}

PUT(url: baseURL⁄"ENDPOINT", headers: [.UserAgent("Restify")], body: "MyData", expectedStatus: [.OK]).send { error in
    if let error = error {print(error)}
}

DELETE(url: baseURL⁄"ENDPOINT"⁄"myID", headers: [.UserAgent("Restify")], expectedStatus: [.OK]).send { error in
    if let error = error {print(error)}
}
```

###  Authentication

Restify does not provide any highlevel implementation to handly authentication at the moment. As a workaround, the `Restify` struct offers a callback to modify the `URLRequest` accordingly  

```swift
import Restify
import CryptoKit

Restify.requestModifier = { request in

    request.set(header: .Authorization("Basic QWxhZGRpbjpPcGVuU2VzYW1l"))

    let contentMD5 = CryptoKit.Insecure.MD5.hash(data: request.httpBody!).description
    request.set(header: .ContentMD5(contentMD5))
}

```


## License

MIT license; see [LICENSE](LICENSE.md).
(c) 2020
