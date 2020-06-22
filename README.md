<p align="center">
<img src = "DOC/RestifyBanner@0.5x.png" alt="FitsCore">
</p>

<p align="center">
<a href="LICENSE">
<img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
<a href="https://swift.org">
<img src="https://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
</a>
</p>

A Swift library to quickly build REST client apps. 

## Description

Even with REST being extremely common these days, implementing REST interfaces in [Swift](https://swift.org)  requires a lot of boilderplate code. This library provides a extremely straightforward approach to implement REST intefaces quick and easy. It offers nice and clean syntax which wraps around the standard `URLRequest` and `JSONEncoder` / `JSONDecoder` implementations.

## Getting started

### Swift Package Manager

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
HTTPS(host: "images-api.nasa.gov")
    .GET("/search")
    .query(.parameter("q", searchTerm))
    .send(.OK) { (result : JSONResponse) in
        self.results = result.collection.items
    }
```

### GET / POST / PUT / DELETE

```swift

let baseURL = HTTP(host: "domain.tld", path: "/api")

baseURL.GET("/Endpoint")
    .header(.UserAgent("Restify"))
    .send(.OK) { (response : JSONResponse ) in
        // process response
    }

baseURL.POST("/Endpoint")
    .header(.UserAgent("Restify"))
    .query(.parameter("id", myID))
    .body("Hello World")
    .send(.Accepted) { (response : JSONResponse ) in
        // process response
    }

baseURL.PUT("/Endpoint")
    .header(.UserAgent("Restify"))
    .query(.parameter("id", myID))
    .send(.Created) { (response : JSONResponse ) in
        // process response
    }

baseURL.DELTE("/Endpoint")
    .header(.UserAgent("Restify"))
    .query(.parameter("id", myID))
    .send(.OK) { (response : JSONResponse ) in
        // process response
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
